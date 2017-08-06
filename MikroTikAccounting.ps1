$Response = Invoke-WebRequest -Uri http://10.14.252.1/accounting/ip.cgi
$AccArray =  $Response.Content -split "`n"
$AccArray[2]