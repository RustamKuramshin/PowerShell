$sb = { $1CexeFilePath = 'C:\Program Files (x86)\1cv8\8.3.11.3034\bin'
        $Arg = '/IBConnectionString "Srvr=1CSQL:1741;Ref=test8;"', "/N Администратор", "/P TAdmin4545", "/C TCA"

        Start-Process -FilePath (Join-Path -Path $1CexeFilePath -ChildPath "1cv8c.exe") -ArgumentList $Arg}

Invoke-Command -ComputerName 1C_SQL -Credential pp.local\r.kuramshin -ScriptBlock $sb

Read-Host