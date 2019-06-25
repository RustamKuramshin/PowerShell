Stop-Process -Name 1cv7* -Force
Stop-Process -Name hpmup* -Force

$WebClient = New-Object System.Net.WebClient

#Соответствие файлов с FTP и выгружаемых\загружаемых из\в 1С в офисе

#OUTFile --> 1C_inFile : PBC.zip скачивается С ftp и помещается в нужный 1С каталог
$OUTFile = "ftp://82.204.178.74/rostov/SMALL_BUSINESS/out/PBC.zip"
$1C_inFile  = "D:\db\RostovMFarm\CP\PBC.zip"

#INFile <-- 1C_outFile : PBD.zip загружается НА ftp 
$INFile  = "ftp://82.204.178.74/rostov/SMALL_BUSINESS/in/PBD.zip"
$1C_outFile = "D:\db\RostovMFarm\PC\PBD.zip"

$WebClient.Proxy = $null

$FTPCredential = New-Object System.Net.NetworkCredential
$FTPCredential.UserName = "rostov"
$FTPCredential.Password = "56879"

$WebClient.Credentials = $FTPCredential

$WebClient.DownloadFile($OUTFile, $1C_inFile)

$ConfigArgument = "config /DD:\db\RostovMFarm /NАдминистратор /Pbase2013 /@D:\db\RostovMFarm\Autochange\2_Obmen.prm"

Start-Process -FilePath "C:\Program Files\1c77sqlvigruz\BIN\1cv7s.exe" -ArgumentList $ConfigArgument -Wait

if (Test-Path -Path $1C_outFile){

    $WebClient.UploadFile($INFile, $1C_outFile)
	
}