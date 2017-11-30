$connectionString = 'Srvr="";Ref="";Usr="";Pwd="";'
$V83Application = New-Object -ComObject V83.Application
$V83Application.Connect($connectionString)
$V83Application.Visible = $true
$V83Application | gm