$conf = Read-Host -Prompt "Укажите конфигурацию (bp, zup или ut)"

$Bases = "eo_$conf","ik_$conf","lu_$conf","ltc_$conf","lm_$conf","ol_$conf","sto_$conf","ug_$conf","uo_$conf","us_$conf"

$FatClient = 'C:\Program Files (x86)\1cv8\8.3.10.2561\bin\1cv8.exe'

$Date = Get-Date -Format ddMMyyyy

ForEach ($base in $Bases){
    
    if (-not (Test-Path -Path "E:\dt\$base\")){
    
        New-Item -Path "E:\dt\" -Name $base -ItemType "directory"

    }

    $DTname = $base + "_" +$Date
    
    $DesignerArg = "DESIGNER /S 192.168.221.23\$base /N Администратор /P A12pAR /WA- /DumpIB E:\dt\$base\$DTname.dt"
    
    Start-Process -FilePath $FatClient -ArgumentList $DesignerArg -Wait -ErrorAction SilentlyContinue

}

ForEach ($base in $Bases){

    $DTname = $base + "_" +$Date

    if (Test-Path -Path "E:\dt\$base\$DTname.dt"){
    
        Write-Host "$base : DT-файл успешно выгружен!"

    }
    else{
    
        Write-Host "$base : DT-файл НЕ выгружен! Попробуйте еще раз!"

    }

}

Read-Host