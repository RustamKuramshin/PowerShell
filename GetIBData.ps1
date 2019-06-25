
$WSRef = New-WebServiceProxy -Uri "http://localhost:80/trade/ws/exchange.1cws?wsdl"

$WSRef | Get-Member

$IBData = $WSRef.GetIBData("Справочник.Номенклатура")

$IBData
