$1CexeFilePath = "C:\Program Files (x86)\1cv8\8.3.11.3034\bin"

$Arg = '/IBConnectionString "Srvr=1CSQL:1741;Ref=sale_profpress_tc;"','/N Администратор','/P TestCenter123','/C TCA'
 
Start-Process -FilePath (Join-Path -Path $1CexeFilePath -ChildPath "1cv8c.exe") -ArgumentList $Arg -WindowStyle Hidden