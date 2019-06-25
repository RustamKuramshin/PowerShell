$Headers = @{
'Host' = "downloads.v8.1c.ru";
#'Proxy-Authorization' = "NTLM TlRMTVNTUAABAAAAB7IIogkACQArAAAAAwADACgAAAAKAKs/AAAAD0NBVFdPUktHUk9VUA==";
'Authorization' = "Basic OTM1MDI0ODpxajRnTFN6NA==";
'User-Agent' = "1C+Enterprise/8.3";
'Accept' = "*/*";
}

$web = Invoke-WebRequest -Uri 'http://downloads.v8.1c.ru/tmplts/v8cscdsc.lst' -Headers $Headers