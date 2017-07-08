$files=Get-ChildItem  -File -Recurse

$pwd=Get-Location

foreach ($file in $files)
{  

    Set-Location $file.DirectoryName
    
    &"C:\Program Files\7-Zip\7z.exe" x $file.FullName -o*
    
    Set-Location $pwd   
} 

