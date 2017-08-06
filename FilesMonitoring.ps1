$FilesExt = @{}
$files = Get-ChildItem -Path "Z:\" -Recurse
Foreach ($file in $files){

    If($FilesExt.Keys -contains $file.Extension){
        $FilesExt[$file.Extension] += 1
    }
    else{
        $FilesExt[$file.Extension] = 1
    }
}
$FilesExt > D:\FilesMonitoring.txt
