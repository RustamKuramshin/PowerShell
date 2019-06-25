Clear-Host

Import-Module -Name SqlServer

$pass = ConvertTo-SecureString -String 'A12pAR' -AsPlainText -Force

Set-Location -Path "SQLSERVER:\SQL\db-01\DEFAULT\Databases\bp_tst_base"

Invoke-Sqlcmd -Query 'SELECT * FROM [Params]' -Username 'sa' -Password $pass