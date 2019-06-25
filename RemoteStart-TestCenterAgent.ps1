$Arg = 'C:\Program Files (x86)\1cv8\8.3.11.3034\bin\1cv8c.exe /IBConnectionString "Srvr=1CSQL:1741;Ref=test8;" /N Администратор /P TAdmin4545 /C TCA'

Invoke-WmiMethod –ComputerName it-kuramshin -Class Win32_Process -Name Create -ArgumentList $Arg -Credential (Get-Credential -Credential prtg@pp.local)
Read-Host