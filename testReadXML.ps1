[xml]$xmlParam = New-Object System.Xml.XmlDocument

$dec = $xmlParam.CreateXmlDeclaration("1.0", "UTF-8", $null)

$xmlParam.AppendChild($dec)

$root = $xmlParam.CreateNode("element", "��������������", $null)

$1cBaseElem = $xmlParam.CreateNode("element", "����1�", $null)
$1cBaseElem.SetAttribute("����������������", "uo-ut")
$1cBaseElem.SetAttribute("�����", "����� �������")
$1cBaseElem.SetAttribute("������", "�� ($)")


$root.AppendChild($1cBaseElem)
$xmlParam.AppendChild($root)



$xmlParam = [xml](Get-Content -Path .\��������������.xml -Encoding UTF8)

$bases = @($xmlParam.��������������.����1�.����������������)
$priceType = @($xmlParam.��������������.����1�.������)
$i = 0
foreach($base in $bases){

    Write-Host $base, $priceType[$i]
    $i++


}