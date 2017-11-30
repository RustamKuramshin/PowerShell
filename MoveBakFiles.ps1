$Backups = ""          #Расположение каталога с бэкапами SQL Server
$CountSubFolder =      #Количество подкаталогов в нем. Предполагается, что в этом каталоге один уровень вложенности, иначе алгоритм нужно менять.
$DirForBakFiles = ""   #Расположение каталога, в который должны быть скопированы бэкапы

Get-ChildItem -Path $Backups -File -Recurse | Sort-Object -Property CreationTime -Descending | `
Select-Object -First $CountSubFolder | Move-Item -Destination $DirForBakFiles