Clear-Host
if(Get-HotFix -Id KB4041681 -ErrorAction SilentlyContinue){

    Write-Host "Будет выполнено удаление обновления Windows..."

    Start-Process "wusa" -ArgumentList "/uninstall /kb:4041681" -Wait
  
   
}else{

    Write-Host "Обновление KB4041681 не найдено!"
  
}

Read-Host "Press any key"