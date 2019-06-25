function Transfer-IDN ($domain, $coding){
    
    #��� �������������� IDN

    $idn = new-object System.Globalization.IdnMapping 
    
    if($coding -eq "ascii"){
        
        $idn.GetAscii("$domain")

    }
    
    if($coding -eq "unicode"){
        
        $idn.GetUnicode(("$domain"))

    }
}

$domainName = '�����������.��' 

Write-Host ������ ������� ���: $domainName

$domainName = Transfer-IDN -domain $domainName -coding ascii

Write-Host ����� ������� ���: $domainName

$webService = New-WebServiceProxy -Uri "http://www.webservicex.net/whois.asmx?WSDL"

($webService.GetWhoIs($domainName)).GetEnumerator
