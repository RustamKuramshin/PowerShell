$bakFiles = Get-ChildItem *bak
$bakLenght = @($bakFiles|%{$_.Length/1GB})


foreach ($bak in $bakLenght){
    $bak
}