$fatClient  = ''
$1cSrv      = ''
$1cAdmPass  = ''
$1cAdm      = ''
$sharePath  = ''
$pricesPath = $sharePath
$ftpPath    = ''
$ftpPass    = ''
$ftpLogin   = ''

$xmlParam = [xml](Get-Content -Path $sharePath\—клады»“ипы÷ен.xml -Encoding UTF8)
$bases = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.»м€ЅазыЌа—ервере)
$pricesTypes = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.“ип÷ен)
$pricesTypesNames = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.“ип÷ен»м€)
$warehouses = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.—клад)
$warehousesNames = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.—клад»м€)
$firms      = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.‘ирма)
$uniqueFirms = $firms | Select-Object -Unique
$clients      = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—. лиент)
$uniqueCustomers = $clients | Select-Object -Unique

$i = 0

foreach($base in $bases){

    $pricesFile = "P_" + $firms[$i] + "_" + $clients[$i] + "_" + $pricesTypesNames[$i] + "_" + $warehousesNames[$i]
    $runParam = $pricesTypes[$i] + "**" + $warehouses[$i] + "**" + $pricesFile
    $runParam = '"'+$runParam+'"'

    $enterpriseArg = "/S $1cSrv\$base /N $1cAdm /P $1cAdmPass /Debug /C $runParam `
    /Execute $sharePath\¬ыгрузка÷енƒл€—айта.epf /WA- /Out $sharePath\ѕлатформаЋог.txt -NoTruncate"

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

$webClient = New-Object System.Net.WebClient
$webClient.Proxy = $null

$ftpCredential = New-Object System.Net.NetworkCredential
$ftpCredential.UserName = $ftpLogin
$ftpCredential.Password = $ftpPass

$webClient.Credentials = $ftpCredential

$timeStamp = Get-Date -Format ddMMyyyyTHHmmss
$date = Get-Date -Format ddMMyyyy
$time = Get-Date -Format THHmmss

if (-not (Test-Path -Path "$sharePath\hystory\$date\$time")){

    New-Item -Path "$sharePath\hystory\$date\$time" -ItemType Directory -Force -ErrorAction SilentlyContinue

}

foreach ($customer in $uniqueCustomers){

    foreach ($firm in $uniqueFirms){

        Compress-Archive -Path "$sharePath\P_$firm`_$customer*.csv" -CompressionLevel Optimal -DestinationPath "$sharePath\P_$firm`_$customer"
        
        Compress-Archive -Path "$sharePath\P_$firm`_$customer*.csv" -CompressionLevel Optimal -DestinationPath "$sharePath\hystory\$date\$time\P_$firm`_$customer" -ErrorAction SilentlyContinue

    } 

}

Get-ChildItem -Path $pricesPath -File -Filter *.csv | Remove-Item

$prices = Get-ChildItem -Path $pricesPath -File -Filter *.zip

foreach ($price in $prices){

    $webClient.UploadFile($ftpPath + $price.Name , $price.FullName)

}

Get-ChildItem -Path $pricesPath -File -Filter *.zip | Remove-Item