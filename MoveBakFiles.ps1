$Backups = ""          #������������ �������� � �������� SQL Server
$CountSubFolder =      #���������� ������������ � ���. ��������������, ��� � ���� �������� ���� ������� �����������, ����� �������� ����� ������.
$DirForBakFiles = ""   #������������ ��������, � ������� ������ ���� ����������� ������

Get-ChildItem -Path $Backups -File -Recurse | Sort-Object -Property CreationTime -Descending | `
Select-Object -First $CountSubFolder | Move-Item -Destination $DirForBakFiles