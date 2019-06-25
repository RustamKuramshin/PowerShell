$fatClient  = 'C:\Program Files (x86)\1cv8\8.3.10.2561\bin\1cv8.exe'
$sharePath  = '\\ent-01\Logs'
$epfName = '����������������������������10_����.epf'

$xmlParam = [xml](Get-Content -Path .\BasesList.xml -Encoding UTF8)

$basesNamesOnServer = @($xmlParam.DatabaseList.Base1C.BasesNameOnServer)
$servers1C = @($xmlParam.DatabaseList.Base1C.Server1C)
$userNames = @($xmlParam.DatabaseList.Base1C.Username)
$passwords = @($xmlParam.DatabaseList.Base1C.Password)
$accessCodes = @($xmlParam.DatabaseList.Base1C.AccessCode)
$RunParameters = @($xmlParam.DatabaseList.Base1C.RunParameter)

#$firms      = @($xmlParam.��������������.����1�.�����)
#$uniqueFirms = $firms | Select-Object -Unique

$i = 0

foreach($BasesNameOnServer in $basesNamesOnServer){
    
    Write-Host $BasesNameOnServer
    
    $runParameter = $RunParameters[$i] + ";" 
    $runParameter = '"'+$runParameter+'"'

    $enterpriseArg = "/S "+$servers1C[$i]+"\$BasesNameOnServer /UC "+$accessCodes[$i]+" /N $userNames[$i] `
    /P "+$passwords[$i]+" /Debug /C $runParameter /Execute $PSScriptRoot\$epfName /WA- /Out $PSScriptRoot\������������.txt -NoTruncate"

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

Read-Host
