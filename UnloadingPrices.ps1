$fatClient  = ''
$1cSrv      = ''
$1cAdmPass  = ' '
$1cAdm      = ''
$sharePath  = ''
$pricesPath = $sharePath
$ftpPath    = ''
$ftpPass    = ''
$ftpLogin   = ''

$xmlParam = [xml](Get-Content -Path $sharePath\ÑêëàäûÈÒèïûÖåí.xml -Encoding UTF8)
$bases = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.ÈìÿÁàçûÍàÑåðâåðå)
$pricesTypes = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.ÒèïÖåí)
$pricesTypesNames = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.ÒèïÖåíÈìÿ)
$warehouses = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.Ñêëàä)
$warehousesNames = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.ÑêëàäÈìÿ)
$firms      = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.Ôèðìà)
$uniqueFirms = $firms | Select-Object -Unique
$clients      = @($xmlParam.ÑêëàäûÈÒèïûÖåí.Áàçà1Ñ.Êëèåíò)
$uniqueCustomers = $clients | Select-Object -Unique

$i = 0

foreach($base in $bases){

    $pricesFile = "P_" + $firms[$i] + "_" + $clients[$i] + "_" + $pricesTypesNames[$i] + "_" + $warehousesNames[$i]
    $runParam = $pricesTypes[$i] + "**" + $warehouses[$i] + "**" + $pricesFile
    $runParam = '"'+$runParam+'"'

    $enterpriseArg = "/S $1cSrv\$base /N $1cAdm /P $1cAdmPass /Debug /C $runParam `
    /Execute $sharePath\ÂûãðóçêàÖåíÄëÿÑàéòà.epf /WA- /Out $sharePath\ÏëàòôîðìàËîã.txt -NoTruncate"

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
