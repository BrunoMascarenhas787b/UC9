CREATE DATABASE LojaCDs;
GO

USE LojaCDS;
GO

-- TABELA CLIENTES
CREATE TABLE Clientes ( 
	ClienteID INT IDENTITY PRIMARY KEY,
	Nome VARCHAR (100) NOT NULL,
	Email VARCHAR (100) UNIQUE 
	-- "Unique" - não permite que dois cliente tenham o mesmo e-mail na tabela.
);

-- TABELA DE CDS
CREATE TABLE CDs ( 
	CD_ID INT IDENTITY PRIMARY KEY,
	Titulo VARCHAR (100) NOT NULL,
	Artista VARCHAR (100) NOT NULL,
	Preco DECIMAL (10, 2) CHECK (PRECO > 0) 
	-- O "Check" valida que o preço sempre seja maior que zero; valores <= 0 são rejeitados.
);

-- TABELA DE PEDIDOS
CREATE TABLE Pedidos ( 
	Pedido_ID INT IDENTITY PRIMARY KEY,
	ClienteID INT NOT NULL,
	DataPedido DATETIME DEFAULT GETDATE (), 
	-- "Default" se o usuário não informar a data, o banco usa a data/hora atual
	Status VARCHAR (20) DEFAULT 'Pendente', 
	-- "Default" se o usuario não informar o status, automaticamente grava pendente
	CONSTRAINT FK_Pedidos_Cliente FOREIGN KEY  (ClienteID) 
	-- "Constraint": Cria uma restrição chamada FK_Pedidos_Clientes
		REFERENCES Clientes(CLienteID) 
		-- FOREIGN KEY, Obriga que o clienteID exista na tabela Clientes (integridade referencial) 
);

-- TABELA DE ITENSPEDIDO
CREATE TABLE ItensPedido ( 
	ItemID INT IDENTITY PRIMARY KEY,
	Pedido_ID INT NOT NULL, 
	CD_ID INT NOT NULL,
	Quantidade INT CHECK (Quantidade >=1),
	-- CHECK: impede inserir quantidade menor que 1(não deixa o 0 e nem valores negativos)
	PrecoUnitario DECIMAL (10, 2) CHECK (PrecoUnitario >0) 
	CONSTRAINT FK_ItensPedidos_Pedidos FOREIGN KEY (Pedido_ID)
	-- Constraint: chave estrangeira ligando ItensPedidos -> Pedidos
	REFERENCES Pedidos(Pedido_ID), 
	-- obrigado que o PedidoID exista na tabela Pedidos.
	CONSTRAINT FK_ItensPedidos_CDs FOREIGN KEY (CD_ID)
	-- CONSTRAINT: chave estrangeiras ligando ItensPedido -> CDs
	REFERENCES CDs(CD_ID)
);

-- Tabela de Promoção
CREATE TABLE PromocaoCD ( 
	CD_ID INT NOT NULL, 
	DescontoPercentual INT CHECK (DescontoPercentual BETWEEN 0 AND 100)
	-- Check: o desconto tem que esta entre 0 e 100
);


-- Inserção de Clientes
INSERT INTO Clientes (Nome, Email) VALUES
('Ana Souza','ana@teste.com'),
('Bruno Lima','bruno@teste.com'),
('Carla Ferreira','carla@teste.com'),
('Diego Martins','diego@teste.com');
 
-- Inserção de CDs
INSERT INTO CDs (Titulo, Artista, Preco) VALUES
('Rock Clássicos','Vários Artistas',39.90),
('Pop Hits','DJ Pop',29.90),
('Sertanejo Raiz','Duo Sertanejo',24.90),
('Jazz Night','John Jazz',34.90),
('Indie Vibes','Banda Indie',27.90);
 
-- Inserção de Pedidos
INSERT INTO Pedidos (ClienteID, DataPedido, Status) VALUES
(1,'2025-11-01 10:00:00','Pendente'),
(1,'2025-11-02 15:30:00','Pago'),
(2,'2025-11-03 09:20:00','Cancelado'),
(3,'2025-11-04 19:45:00','Pago');
 
-- Inserção de ItensPedido
INSERT INTO ItensPedido (Pedido_ID, CD_ID, Quantidade, PrecoUnitario) VALUES
(1,1,1,39.90),
(1,2,2,29.90),
(2,3,1,24.90),
(3,2,1,29.90),
(4,4,3,34.90);
 
-- Inserção de Promoções
INSERT INTO PromocaoCD (CD_ID, DescontoPercentual) VALUES
(1,10),(2,15),(6,20);  -- se existir FK para CDs aqui no futuro, o CDID = 6 vai gerar erro se não houver CD com ID 6.

-- JOINS
-- INNER JOIN
SELECT ip.ItemID,
	ip.Pedido_ID,
	c.TItulo,
	c.Artista,
	(ip.Quantidade * Ip.PrecoUnitario) As TotalItem
	-- calcula o total de cada item (quantidade x preço unitário)
	FROM ItensPedido Ip
	INNER JOIN CDs c ON ip.CD_ID = c.CD_ID
-- Retorna apenas os registros que existem ao mesmo tempo em ItensPedido e CDs

-- LEFT JOIN
SELECT cl.clienteID,
		cl.Nome,
		p.Pedido_ID,
		p.DataPedido,
		p.Status
FROM Clientes cl
LEFT JOIN Pedidos p ON cl.ClienteID = P.ClienteID
-- Retorna TODOS os Clientes (Tabelas Esquerda) mesmo que não tenha pedidos.

-- RIGHT JOIN
SELECT cl.ClienteID,
		cl.Nome,
		p.Pedido_ID,
		p.DataPedido,
		p.Status
FROM Clientes cl
RIGHT JOIN Pedidos p ON cl.ClienteID = P.ClienteID
-- Retorna todos os pedidos (Tabela Direita) mesmo que não existam clientes correspondentes. 

-- FULL JOIN
SELECT c.CD_ID AS CD_ID_TabelaCDs, c.Titulo,
		p.CD_ID AS CD_ID_TabelaCDs, p.DescontoPercentual
FROM CDs c
FULL OUTER JOIN PromocaoCD p ON c.CD_ID = p.CD_ID;

-- FULL OUTER JOIN: junta as 2 tabelas trazendo:
-- CDs que etm promoção,
-- CDS sem promoção (PromocaoCD vem NULL)
-- Promocao sem Cd correspondente (CD vem Null)
-- ou seja, mostra tudo de ambos os lados, com null onde não houver correspondencia. 


-- DESAFIO: 
-- JOIN com TOTALIZADOR
SELECT p.Pedido_ID, 
		cl.nome AS NomeCliente, 
		p.DataPedido, 
		p.Status,
		SUM(ip.qUANTIDADE * ip.PrecoUnitario) AS TotalPedido
		-- totalizar: somar o valor de todos os itens de cada pedido.
FROM Pedidos p
INNER JOIN Clientes cl ON cl.ClienteID = p.ClienteID -- INNER JOIN: SÓ PEDIDOS QUE TEM CLIENTE VALIDO
INNER JOIN ItensPedido ip ON ip.Pedido_ID = p.Pedido_ID -- INNER JOIN: SÓ PEDIDOS QUE TEM ITENS ASSOCIDADOS
GROUP BY p.Pedido_ID, cl.Nome, p.DataPedido, p.Status -- agrupa por pedido para que o SUM calcule o total de cada pedido.

