$SharedEx = "F:\Обмен\_Общий\*"          #Расположение каталога который нужно очистить

Set-ExecutionPolicy Bypass -Force
Remove-Item -Path $SharedEx -Recurse -Force -Confirm:$false