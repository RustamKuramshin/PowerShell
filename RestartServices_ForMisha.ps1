$superSb = {

$sb = {

    Write-Host "Выполняется остановка служб"

    Get-Service -DisplayName '*1с*', '*слк*', '*hasp*' | Stop-Service

    Start-Sleep -Seconds 10

    Write-Host "Выполняется запуск служб"

    Get-Service -DisplayName '*1с*', '*слк*', '*hasp*' | Start-Service

}

    Invoke-Command -ComputerName ent-01 -ScriptBlock $sb

    Write-Host "Миша, все операции выполнены :)"

    Read-Host

}

Start-Process powershell.exe -Verb runAs -ArgumentList "-command $superSb"