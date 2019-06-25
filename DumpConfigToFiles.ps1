$catalogBin = "C:\Program Files (x86)\1cv8\8.3.11.3034\bin"
$configExe = "1cv8.exe"
$uploadXMLPath = "D:\TC\TC_XML" 
$outLogFile = "D:\log.txt"

$IBConnectionString = 'Srvr="1CSQL:1741";Ref="test8";Usr="Администратор";Pwd="TAdmin4545";'

$Arg = "DESIGNER","/IBConnectionString $IBConnectionString",`
"/DumpConfigToFiles $uploadXMLPath -format Plain","/Out $outLogFile"

Start-Process -FilePath (Join-Path -Path $catalogBin -ChildPath $configExe) -ArgumentList $Arg

