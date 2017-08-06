#$Q = "PowerShell"
#$GR = Invoke-WebRequest -Uri "https://www.google.ru/search?q=$Q" -SessionVariable session
#$GR



$Query = "PowerShell"
$Response = Invoke-WebRequest -Uri "https://www.google.ru/search?newwindow=1&hl=ru&site=webhp&source=hp&q=$Query"
$Response.Links.href | Where-Object {($_ -notlike "*google*") -and ($_ -like "*http*")}