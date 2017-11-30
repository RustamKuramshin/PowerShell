$Base = Read-Host -Prompt "Укажите название базы на сервере приложений"

$FatClient = ''

$Date = Get-Date -Format ddMMyyyy

if (-not (Test-Path -Path "")){
    
    New-Item -Path "" -Name $Base -ItemType "directory"

}

$DTname = $Base + "_" +$Date

$DesignerArg = "DESIGNER /S  /N  /P  /WA- /DumpIB "

Start-Process -FilePath $FatClient -ArgumentList $DesignerArg -Wait

if (Test-Path -Path ""){
    
    Write-Host "DT-файл успешно выгружен!"

}
else{
    
    Write-Host "DT-файл НЕ выгружен! Попробуйте еще раз!"

}

Read-Host