$superSb = {

    $sb = {

        Write-Host "Выполняется остановка служб"

        Get-Service -DisplayName '*hasp*' | Stop-Service

        Start-Sleep -Seconds 10

        Write-Host "Выполняется запуск служб"

        Get-Service -DisplayName '*hasp*' | Start-Service

    }

    Invoke-Command -ComputerName ent-02, ent-03 -ScriptBlock $sb

    Write-Host "Все операции выполнены"

    Read-Host

}

Start-Process powershell.exe -Verb runAs -ArgumentList "-command $superSb"