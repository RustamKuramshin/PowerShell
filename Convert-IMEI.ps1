Clear-Host
$pass = ConvertTo-SecureString 'G90212gOrgYI' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential('1crosprom', $pass)

$res =  Invoke-WebRequest -Uri http://10.61.2.8:8091/do.get.current.user -Credential $cred
$obj = ConvertFrom-Json $res

ForEach ($device in $obj.result.devices) {
    $postFix = $device.Substring($device.Length - 4, 4)
    Write-Host "$device --> +7999123$postFix"
}

Read-Host