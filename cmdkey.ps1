Write-Host "Connecting to TestCenter.pp.local"

$server = 'TestCenter'
$userSubString = 'TestCenter\User'
$password = 'Qq123456'

for($i=1;$i -le 5;$i++){

    $user = $userSubString + $i;
    
    $arg = "/add:$server /user:$user /pass:$password" 

    & "cmdkey.exe" $arg

    & "mstsc.exe" "/v:$Server" 
      
}