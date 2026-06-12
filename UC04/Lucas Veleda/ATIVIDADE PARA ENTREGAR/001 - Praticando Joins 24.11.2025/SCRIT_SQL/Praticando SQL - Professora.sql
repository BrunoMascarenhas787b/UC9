CREATE DATABASE BANCO_JOIN;

USE BANCO_JOIN;

CREATE TABLE TabelaA
(Nome varchar(50) null);

CREATE TABLE TabelaB
(Nome varchar(50) null);

Select * from TabelaA;
Select * from TabelaB;

-- Insert na Tabela A
INSERT INTO TabelaA VALUES('Fernanda')
INSERT INTO TabelaA VALUES('Josefa')
INSERT INTO TabelaA VALUES('Luiz')
INSERT INTO TabelaA VALUES('Fernando')

-- Insert na Tabela B
INSERT INTO TabelaB VALUES('Carlos')
INSERT INTO TabelaB VALUES('Manuel')
INSERT INTO TabelaB VALUES('Luiz')
INSERT INTO TabelaB VALUES('Fernando')

-- Innner Join
-- Mostrar somente os nomes que estão nas 2 tabelas

Select A.Nome, B.Nome
FROM TabelaA A
INNER JOIN TabelaB B ON A.Nome = B.Nome

-- 2. Left join
-- Mostra todos os nomes da tabela A, mesmo que não exista na tabela B.
SELECT A.Nome, B.Nome
FROM TabelaA A
LEFT JOIN TabelaB B ON A.Nome = B.Nome


-- 3. Right join
-- Mostra todos os nomes da tabela A, mesmo que não exista na tabela B.
SELECT A.Nome, B.Nome
FROM TabelaA A
RIGHT JOIN TabelaB B ON A.Nome = B.Nome

-- 4. FULL JOIN
-- Mostra todos os nomes das Tabelas, combinando quando dá e deixando o null quando não tem correspondente.
SELECT A.Nome, B.Nome
FROM TabelaA A
FULL JOIN TabelaB B ON A.Nome = B.Nome

-- 5. CROSS JOIN
-- Combina cada linha da TabelaA com cada linha de TabelaB.
SELECT A.Nome, B.Nome
FROM TabelaA A
CROSS JOIN TabelaB B

-- 6. SELF JOIN
-- TabelaA junta com ela mesmo, não faz sentido, mas só pra mostrar a sintaxe
SELECT A1.Nome AS Nome1, A2.Nome As Nome2
FROM TabelaA A1
JOIN TabelaA A2 ON A1.Nome = A2.Nome;


