Clear-Host

Import-Module -Name SqlServer

Invoke-Sqlcmd -ServerInstance "192.168.222.31" -Database 'bp_tst_base' -Username 'sa' `
-Password 'A12pAR' -Query "SELECT * FROM [Params]"

Read-Host