#������������� ����������
$fatClient  = 'C:\Program Files (x86)\1cv8\8.3.10.2561\bin\1cv8.exe'
$1cSrv      = 'ent-02'
$1cAdmPass  = 'A12pAR'
$1cAdm      = '�������������'
$sharePath  = '\\ent-01\Logs'
$pricesPath = $sharePath
$ftpPath    = 'ftp://autometrika-www.parts-soft.ru/'
$ftpPass    = '+m/lfuvj3Hz51ck4dj7l5qHYWrPzc='
$ftpLogin   = 'supplierftp'

#������ �� �������� xml-����� ��������� �������� �������
$xmlParam = [xml](Get-Content -Path $sharePath\��������������.xml -Encoding UTF8)
$bases = @($xmlParam.��������������.����1�.����������������)
$pricesTypes = @($xmlParam.��������������.����1�.������)
$pricesTypesNames = @($xmlParam.��������������.����1�.���������)
$warehouses = @($xmlParam.��������������.����1�.�����)
$warehousesNames = @($xmlParam.��������������.����1�.��������)
$firms      = @($xmlParam.��������������.����1�.�����)
$uniqueFirms = $firms | Select-Object -Unique
$clients      = @($xmlParam.��������������.����1�.������)
$uniqueCustomers = $clients | Select-Object -Unique

$i = 0

#������ ���������. ����������� ��������� ��������� ������ � ������������ ������ .NET ��� ������� ��������� � �������� ���������� �� ������
foreach($base in $bases){

    $pricesFile = "P_" + $firms[$i] + "_" + $clients[$i] + "_" + $pricesTypesNames[$i] + "_" + $warehousesNames[$i]
    $runParam = $pricesTypes[$i] + "**" + $warehouses[$i] + "**" + $pricesFile
    $runParam = '"'+$runParam+'"'

    $enterpriseArg = "/S $1cSrv\$base /N $1cAdm /P $1cAdmPass /Debug /C $runParam `
    /Execute $sharePath\�������������������.epf /WA- /Out $sharePath\������������.txt -NoTruncate"

    $1cExe = New-Object System.Diagnostics.Process
    $1cExe.StartInfo.Filename = $fatClient
    $1cExe.StartInfo.Arguments = $enterpriseArg
    $1cExe.StartInfo.RedirectStandardOutput = $true
    $1cExe.StartInfo.UseShellExecute = $false
    $1cExe.start()
    $1cExe.WaitForExit()

    Remove-Variable -Name '1cExe'

    $i++

}

#�������� ������� .NET ��� ������ � ftp-��������
$webClient = New-Object System.Net.WebClient
$webClient.Proxy = $null

$ftpCredential = New-Object System.Net.NetworkCredential
$ftpCredential.UserName = $ftpLogin
$ftpCredential.Password = $ftpPass

$webClient.Credentials = $ftpCredential

$timeStamp = Get-Date -Format ddMMyyyyTHHmmss
$date = Get-Date -Format ddMMyyyy
$time = Get-Date -Format THHmmss

#���������� ������� � �������� ��� �������� �� ftp-������
if (-not (Test-Path -Path "$sharePath\hystory\$date\$time")){

    New-Item -Path "$sharePath\hystory\$date\$time" -ItemType Directory -Force -ErrorAction SilentlyContinue

}

foreach ($customer in $uniqueCustomers){

    foreach ($firm in $uniqueFirms){

        Compress-Archive -Path "$sharePath\P_$firm`_$customer*.csv" -CompressionLevel Optimal -DestinationPath "$sharePath\P_$firm`_$customer"
        
        Compress-Archive -Path "$sharePath\P_$firm`_$customer*.csv" -CompressionLevel Optimal -DestinationPath "$sharePath\hystory\$date\$time\P_$firm`_$customer" -ErrorAction SilentlyContinue

    } 

}

#�������� ������ ������� � �������� ������� � �������� �� ftp-������
Get-ChildItem -Path $pricesPath -File -Filter *.csv | Remove-Item

$prices = Get-ChildItem -Path $pricesPath -File -Filter *.zip

foreach ($price in $prices){

    $webClient.UploadFile($ftpPath + $price.Name , $price.FullName)

}

#�������� ������ �������
Get-ChildItem -Path $pricesPath -File -Filter *.zip | Remove-Item