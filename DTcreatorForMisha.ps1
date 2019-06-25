$Bases = "inter_ut"
$srv   = "WIN-UTI0NU9BHB6"
$rel   = "2561"

$FatClient = "C:\Program Files (x86)\1cv8\8.3.10.$rel\bin\1cv8.exe"

$Date = Get-Date -Format ddMMyyyy

ForEach ($base in $Bases){
    
    if (-not (Test-Path -Path "E:\dtM\$base\")){
    
        New-Item -Path "E:\dtM\" -Name $base -ItemType Directory

    }

    $DTname = $base + "_" +$Date
    
    $DesignerArg = "DESIGNER /S $srv\$base /N Администратор /P D3chFop6j3 /WA- /Out \\ent-01\Logs\1CLog2.txt -NoTruncate /DumpIB E:\dtM\$base\$DTname.dt"
    
    Start-Process -FilePath $FatClient -ArgumentList $DesignerArg -Wait -ErrorAction SilentlyContinue

}

ForEach ($base in $Bases){

    $DTname = $base + "_" +$Date

    if (Test-Path -Path "E:\dtM\$base\$DTname.dt"){
    
        Write-Host "$base : DT-файл успешно выгружен!"

    }
    else{
    
        Write-Host "$base : DT-файл НЕ выгружен! Попробуйте еще раз!"

    }

}

Read-Host