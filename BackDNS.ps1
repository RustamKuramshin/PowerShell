$OurIP = @()

$OurIP = (Resolve-DnsName -Name mail.civic4d.ru -Type A -Server 8.8.8.8).IPAddress

if(($OurIP -contains "109.70.26.37") -or (($OurIP -contains "194.85.61.76")) ){

    Write-Host "����! IP ������ ��� �� ���������" 

}else{

    Write-Host "���! IP ������ ���������"
}

Read-Host