$superSb = {

$sb = {

    Write-Host "Выполняется остановка служб"

    Get-Service -DisplayName '*1с*', '*слк*', '*hasp*' | Stop-Service

    Start-Sleep -Seconds 5

    Write-Host "Выполняется запуск служб"

    Get-Service -DisplayName '*1с*', '*слк*', '*hasp*' | Start-Service

}

    Invoke-Command -ComputerName ent-02, ent-03 -ScriptBlock $sb

    Write-Host "Все операции выполнены"

}

Start-Process powershell.exe -Verb runAs -ArgumentList "-command $superSb"