$Base = Read-Host -Prompt "Укажите название базы на сервере приложений ent-3"

$FatClient = 'C:\Program Files (x86)\1cv8\8.3.10.2561\bin\1cv8.exe'

$Date = Get-Date -Format ddMMyyyy

if (-not (Test-Path -Path "D:\dt\$Base\")){
    
    New-Item -Path "D:\dt\" -Name $Base -ItemType "directory"

}

$DTname = $Base + "_" +$Date

$DesignerArg = "DESIGNER /S ent-03\$Base /N Администратор /P A12pAR /WA- /DumpIB D:\dt\$Base\$DTname.dt"

Start-Process -FilePath $FatClient -ArgumentList $DesignerArg -Wait

if (Test-Path -Path "D:\dt\$Base\$DTname.dt"){
    
    Write-Host "DT-файл успешно выгружен!"

}
else{
    
    Write-Host "DT-файл НЕ выгружен! Попробуйте еще раз!"

}

Read-Host