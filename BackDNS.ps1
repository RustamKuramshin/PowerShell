$OurIP = @()

$OurIP = (Resolve-DnsName -Name  -Type A -Server 8.8.8.8).IPAddress

if(($OurIP -contains "") -or (($OurIP -contains "")) ){

    Write-Host "����! IP ������ ��� �� ���������" 

}else{

    Write-Host "���! IP ������ ���������"
}

Read-Host