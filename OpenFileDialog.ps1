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

$inputfile = Get-FileName
Write-Host $inputfile