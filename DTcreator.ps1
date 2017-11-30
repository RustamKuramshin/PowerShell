$conf = Read-Host -Prompt "Укажите конфигурацию"

$Bases = ""

$FatClient = ''

$Date = Get-Date -Format ddMMyyyy

ForEach ($base in $Bases){
    
    if (-not (Test-Path -Path "")){
    
        New-Item -Path "" -Name $base -ItemType "directory"

    }

    $DTname = $base + "_" +$Date
    
    $DesignerArg = "DESIGNER /S  /N  /P  /WA- /DumpIB "
    
    Start-Process -FilePath $FatClient -ArgumentList $DesignerArg -Wait -ErrorAction SilentlyContinue

}

ForEach ($base in $Bases){

    $DTname = $base + "_" +$Date

    if (Test-Path -Path ""){
    
        Write-Host "$base : DT-файл успешно выгружен!"

    }
    else{
    
        Write-Host "$base : DT-файл НЕ выгружен! Попробуйте еще раз!"

    }

}

Read-Host