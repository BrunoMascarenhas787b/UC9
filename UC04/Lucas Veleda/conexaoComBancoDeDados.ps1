
<# 
.NAME
    lucasVeleda
.SYNOPSIS
    Projeto aleatorio

#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,400)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$lblCOmando                      = New-Object system.Windows.Forms.Label
$lblCOmando.text                 = "Digite um comando para o SQL"
$lblCOmando.AutoSize             = $true
$lblCOmando.width                = 25
$lblCOmando.height               = 10
$lblCOmando.location             = New-Object System.Drawing.Point(35,31)
$lblCOmando.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$btnEnviar                       = New-Object system.Windows.Forms.Button
$btnEnviar.text                  = "Enviar para o banco de dados"
$btnEnviar.width                 = 296
$btnEnviar.height                = 30
$btnEnviar.location              = New-Object System.Drawing.Point(39,139)
$btnEnviar.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$txtComando                      = New-Object system.Windows.Forms.TextBox
$txtComando.multiline            = $false
$txtComando.width                = 328
$txtComando.height               = 20
$txtComando.location             = New-Object System.Drawing.Point(35,57)
$txtComando.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$lblMensagem                     = New-Object system.Windows.Forms.Label
$lblMensagem.AutoSize            = $true
$lblMensagem.width               = 330
$lblMensagem.height              = 230
$lblMensagem.location            = New-Object System.Drawing.Point(33,99)
$lblMensagem.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($lblCOmando,$btnEnviar,$txtComando,$lblMensagem))


function conexao {
    try {
$resultado = Invoke-Sqlcmd `
    -ServerInstance "$env:COMPUTERNAME\SQLEXPRESS" `
    -Database "MinhaEmpresa" `
    -Query $txtComando.Text `
    -ErrorAction Stop

        if (-not $resultado) {
            $lblMensagem.Text = "Nenhum registro encontrado."
        }
        else {
            $lblMensagem.Text = "Consulta realizada com sucesso:`n"

foreach ($item in $resultado) {

    if ($item.cadastro -eq 1) {
        $statusTexto = "Positivo"
    }
    else {
        $statusTexto = "Negativo"
    }

    $lblMensagem.Text += "`nNome: $($item.nome) | Email: $($item.email) | Status: $statusTexto"
}
        }

    } catch {
        $lblMensagem.Text = "Erro crítico: $($_.Exception.Message)"
    }
}

$btnEnviar.Add_Click({ Conexao })



[void]$Form.ShowDialog()