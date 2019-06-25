$BackLub = "F:\Бухгалтерия"          #Расположение каталога Бухгалтерии
$BackRuk = "F:\Руководство"          #Расположение каталога Руководства
$DirForBakFiles = "I:\EverydayBackup"   #Расположение каталога, в который должны быть скопированы бэкапы
$Log = "D:\log\backuplog.txt"          #Расположение лога
$Date = Get-Date                       #Текущая дата

Set-ExecutionPolicy Bypass -Force      #Разрешаем исполнение любых скриптов

Add-Content -Value "Копирование Руководство начато - $Date" -Path $Log

Copy-Item -Path $BackRuk -Destination $DirForBakFiles -Recurse -Force

If ($?){
    Add-Content -Value "Копирование Руководство завершено - $Date" -Path $Log
}



Add-Content -Value "Копирование Бухгалтерии начато - $Date" -Path $Log

Copy-Item -Path $BackLub -Destination $DirForBakFiles -Recurse -Force

If ($?){
    Add-Content -Value "Копирование Бухгалтерии завершено - $Date" -Path $Log
}