Stop-Process -Name 1cv7* -Force
Stop-Process -Name hpmup* -Force

$WebClient = New-Object System.Net.WebClient

$OUTFile = ""
$INFile = ""

$WebClient.Proxy = $null

$FTPCredential = New-Object System.Net.NetworkCredential
$FTPCredential.UserName = ""
$FTPCredential.Password = ""

$WebClient.Credentials = $FTPCredential

$WebClient.DownloadFile($OUTFile, "")

$ConfigArgument = "config /D /N /P /@"

Start-Process -FilePath "C:\Program Files\1c77sqlvigruz\BIN\1cv7s.exe" -ArgumentList $ConfigArgument -Wait

if (Test-Path -Path ""){

    $WebClient.UploadFile($INFile, "")
	
}