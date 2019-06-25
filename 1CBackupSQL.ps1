Clear-Host

if ((Get-Module -Name SqlServer -ListAvailable) -eq $null){
    Write-Host 'Не установлен модуль SqlServer. Используйте команду: Install-Module -Name SqlServer' -ForegroundColor Green
}

Import-Module -Name SqlServer

$ipDBServer = Read-Host 'IP-адрес сервера с MS SQL Server'
$dbName     = Read-Host 'Имя базы данных'
$fileShare  = Read-Host 'Сетевой путь к папке, в которую сохранить бэкап'

try
{
    Test-Connection -ComputerName $ipDBServer -Count 1 -ErrorAction Stop | Out-Null
}
catch
{
    throw 'Заданный ip-адрес не доступен'
    Read-Host
    exit
}

if((Test-Path -LiteralPath $fileShare) -eq $false){

    throw 'Указанный путь не существует'
    Read-Host
    exit
}

$bakFilePath = Join-Path -Path $fileShare -ChildPath ($dbName + "_" + (Get-Date -Format ddMMyyyyTHHmmss) + '.bak')

Backup-SqlDatabase -ServerInstance $ipDBServer -Database $dbName -Credential (Get-Credential 'sa') -BackupFile $bakFilePath