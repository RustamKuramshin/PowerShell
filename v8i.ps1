Import-Module -Name ActiveDirectory

$user = ''
$pass = ConvertTo-SecureString -String "" -AsPlainText -Force
$credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $user, $pass

$strAddBase = "`nCommonInfoBases=\\fs-01\Support\IBases\gk.v8i"

$usersNames = (Get-ADUser -Filter *).SamAccountName | sort
$i = 0
foreach ($name in $usersNames){

    $v8i_Path = "C:\Users\$name\AppData\Roaming\1C\1CEStart\1CEStart.cfg" 

    if (Test-Path -Path $v8i_Path){
        Write-Host $v8i_Path
        Add-Content -Path $v8i_Path -Value $strAddBase
        $i++
    }
    else{
        Write-Host "User $name not have v8i file"
    } 

}

Write-Host $i

