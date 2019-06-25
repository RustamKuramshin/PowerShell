Import-Module -Name SqlServer
Function Get-FileName
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $PSSCRIPTROOT
    $OpenFileDialog.Title = "Выберете bak-файл" 
    $OpenFileDialog.filter = "bak (*.bak)| *.bak"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

$sqlServer = Read-Host "Имя сервера MS SQL Server"
$db = Read-Host "В какую базу восстановить"


Restore-SqlDatabase -ServerInstance $sqlServer -Database $db -Credential (Get-Credential 'sa') -BackupFile (Get-FileName)

Read-Host
