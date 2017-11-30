[xml]$xmlParam = New-Object System.Xml.XmlDocument

$dec = $xmlParam.CreateXmlDeclaration("1.0", "UTF-8", $null)

$xmlParam.AppendChild($dec)

$root = $xmlParam.CreateNode("element", "—клады»“ипы÷ен", $null)

$1cBaseElem = $xmlParam.CreateNode("element", "Ѕаза1—", $null)
$1cBaseElem.SetAttribute("»м€ЅазыЌа—ервере", "uo-ut")
$1cBaseElem.SetAttribute("—клад", "—клад оптовый")
$1cBaseElem.SetAttribute("“ип÷ен", "»ћ ($)")


$root.AppendChild($1cBaseElem)
$xmlParam.AppendChild($root)



$xmlParam = [xml](Get-Content -Path .\—клады»“ипы÷ен.xml -Encoding UTF8)

$bases = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.»м€ЅазыЌа—ервере)
$priceType = @($xmlParam.—клады»“ипы÷ен.Ѕаза1—.“ип÷ен)
$i = 0
foreach($base in $bases){

    Write-Host $base, $priceType[$i]
    $i++


}