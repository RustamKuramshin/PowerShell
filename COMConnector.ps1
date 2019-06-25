$connectionString = 'Srvr="ent-02";Ref="uo_ut";Usr="Администратор";Pwd="A12pAR";'

function ComProperty ([System.__ComObject]$obj, [string]$value)
{
    <# обращение к свойству COM объекта
    obj - сам COM объект
    value - имя свойства#>

    $return_value = [System.__ComObject].invokemember($value,[System.Reflection.BindingFlags]::GetProperty,$null,$obj, $null)   
    return $return_value;
}

function SetProperty ([System.__ComObject]$obj, [string]$propertyName, [string]$value)
{
    <# инициалиция свойства COM объекта
    obj - сам COM объект
    propertyName - имя свойства
    value - значение свойства#>

    [System.__ComObject].invokemember($propertyName,[System.Reflection.BindingFlags]::SetProperty,$null,$obj, $value)   
    
}
 
function ComMethod ([System.__ComObject]$obj, [string]$Method, [Array]$Params)
{
    <# обращение к методу COM объекта
    obj - сам COM объект
    Method - имя метода
    Params - параметры метода#>

    $return_value = [System.__ComObject].invokemember($Method,[System.Reflection.BindingFlags]::invokeMethod,$null,$obj, $Params)   
    return $return_value;
}

$con = New-Object -ComObject V83.COMConnector
$comObj = $con.Connect($connectionString)

$queryText = @"

ВЫБРАТЬ
    Номенклатура.Наименование КАК Наименование, 
    Номенклатура.Артикул КАК Артикул 
ИЗ 
    Справочник.Номенклатура КАК Номенклатура

"@


$Query = ComMethod -obj $comObj -Method "NewObject" -Params "Запрос"
SetProperty -obj $Query -propertyName "Text" -value $queryText
$QueryResult = ComMethod -obj $Query -Method "Execute"  
$QueryResultIsEmpty = ComMethod -obj $QueryResult -Method "IsEmpty"

$table = @()
 
if ($QueryResultIsEmpty -eq $false){

    $QueryRecordset = ComMethod -obj $QueryResult -Method "Unload"

    foreach($record in $QueryRecordset){
    
        $row = New-Object System.Object
        $row | Add-Member -Type NoteProperty -Name Наименование -Value (ComProperty -obj $record -value "Наименование")
        $row | Add-Member -Type NoteProperty -Name Артикул -Value ([string](ComProperty -obj $record -value "Артикул"))
        
        $table += $row

    }

}


$table | Export-Csv -Path E:\Logs\query.csv -Delimiter ";" -NoTypeInformation -Encoding Default

Write-Host "Запрос выполнен"
Read-Host