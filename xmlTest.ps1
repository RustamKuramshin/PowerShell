[xml]$xmlParam = New-Object System.Xml.XmlDocument

$dec = $xmlParam.CreateXmlDeclaration("1.0","UTF-8",$null)

$xmlParam.AppendChild($dec)

$root = $xmlParam.CreateNode("element","—клады»“ипы÷ен",$null)

$1cBaseElem = $xmlParam.CreateNode("element", "Ѕаза1—", $null)
$1cBaseElem.SetAttribute("»м€ЅазыЌа—ервере", "uo-ut")
$1cBaseElem.SetAttribute("—клад", "—клад оптовый")
$1cBaseElem.SetAttribute("“ип÷ен", "»ћ ($)")


$root.AppendChild($1cBaseElem)
$xmlParam.AppendChild($root)
