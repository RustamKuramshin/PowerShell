function Transfer-IDN ($domain, $coding){
    
    #Для перобразования IDN

    $idn = new-object System.Globalization.IdnMapping 
    
    if($coding -eq "ascii"){
        
        $idn.GetAscii("$domain")

    }
    
    if($coding -eq "unicode"){
        
        $idn.GetUnicode(("$domain"))

    }
}

$domainName = 'стайлтехойл.рф' 

Write-Host Старое доменое имя: $domainName

$domainName = Transfer-IDN -domain $domainName -coding ascii

Write-Host Новое доменое имя: $domainName

$webService = New-WebServiceProxy -Uri "http://www.webservicex.net/whois.asmx?WSDL"

($webService.GetWhoIs($domainName)).GetEnumerator
