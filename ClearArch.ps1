$src = Get-ChildItem -recurse  D:\FTP -Include *.7z | Sort-Object -Descending CreationTime
$origpath = @()
foreach($a in $src){
    try {
        $arhpath = $a.FullName
        & "C:\Program Files\7-Zip\7z.exe" t $arhpath
        if($LASTEXITCODE){
            Remove-Item $arhpath
        }
        else{
            if($origpath -contains $a.DirectoryName){Remove-Item $arhpath}else{$origpath += $a.DirectoryName}
        }
        }
    catch {
        Write-Host "Не удалось выполнить команды"
    }   
}
$origpath = 0