function Transfer-IDN ($domain, $coding){

    $idn = new-object System.Globalization.IdnMapping 
    
    if($coding -eq "ascii"){
        
        $idn.GetAscii("$domain")

    }
    
    if($coding -eq "unicode"){
        
        $idn.GetUnicode(("$domain"))

    }
}

Transfer-IDN -domain 'стайлтехойл.рф' -coding ascii
