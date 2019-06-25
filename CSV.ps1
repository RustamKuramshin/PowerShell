Import-Module -Name ActiveDirectory
$usersNames = Get-ADUser -Filter *
$namesTable = @{}
foreach ($name in $usersNames){
    
    $namesTable[$name.Name -replace "\s",""] = $name.SamAccountName 
}

$file = Import-Csv C:\Users\KuramshinRS\Desktop\УТ11_Пользователи.csv -Encoding Default -Delimiter ";" -Header Company,Name,FullName,Role,SamAccountName

$file | foreach{$_.SamAccountName =$namesTable[$_.FullName -replace "\s",""]}

$file | Export-Csv -Path C:\Users\KuramshinRS\Desktop\finish.csv -Encoding Default -Force