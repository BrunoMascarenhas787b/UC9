cls #limpatela
echo "Eai" # escreval("Eai")
$texto = "Lucas"
$inteiro = (1 + 2)*5
$real = 5.4 / 2
echo $texto, $inteiro, $real
if($texto -eq "Higor") { # -eq é equivalente ao == do visualG
	echo "Esté é o nome do Aluno"
}
else {
	echo "Este não é o aluno"
} # ==
$textoFora = Read-Host "Digite seu nome"
echo $textoFora

switch($inteiro){ #Equivalente ao esolha 
1{
    echo "A variavél é igual 1"
    break
}

15{
    echo "A variavél é igual 15"
    break
}

$controle = 1
while ($controle -le $inteiro) {
echo $controle
$controle ++
}

do { # Equivalente ao repita ate 
echo $controle
$controle ++
} while ($controle -le $inteiro)

for($controle = 15; $controle -ge 0; $controle--) { # Equivalente ao para
    echo
    }