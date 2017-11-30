$OurIP = @()

$OurIP = (Resolve-DnsName -Name  -Type A -Server 8.8.8.8).IPAddress

if(($OurIP -contains "") -or (($OurIP -contains "")) ){

    Write-Host "Черт! IP адреса еще НЕ вернулись" 

}else{

    Write-Host "Ура! IP адреса вернулись"
}

Read-Host