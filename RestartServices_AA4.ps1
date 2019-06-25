$superSb = {

$sb = {

    Write-Host "Выполняется остановка служб"

    Get-Service -DisplayName '*слк*', '*hasp*' | Stop-Service

    Start-Sleep -Seconds 10

    Write-Host "Выполняется запуск служб"

    Get-Service -DisplayName '*слк*', '*hasp*' | Start-Service

}

    Invoke-Command -ComputerName ent-02 -ScriptBlock $sb

    Write-Host "Все операции выполнены"

}

Start-Process powershell.exe -Verb runAs -ArgumentList "-command $superSb"