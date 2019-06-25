<#...#>

$priceFilePath = (Get-ChildItem -Path $PSScriptRoot -Filter *.xls).FullName
$imageFolder = Read-Host -Prompt "Путь к каталогу с картинками"
$destinationFolder = Read-Host -Prompt "Путь к каталогу сохранения выбранных картинок и архива"

$OleDbConn = New-Object System.Data.OleDb.OleDbConnection
$OleDbCmd = New-Object System.Data.OleDb.OleDbCommand
$OleDbAdapter = New-Object System.Data.OleDb.OleDbDataAdapter
$DataTable = New-Object System.Data.DataTable

$OleDbConn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$priceFilePath;Extended Properties=""Excel 12.0;HDR=YES;IMEX=1;"""
$OleDbConn.Open()

$OleDbCmd.Connection = $OleDbConn
$OleDbCmd.CommandText = 'SELECT * FROM [TDSheet$]'
$OleDbAdapter.SelectCommand = $OleDbCmd

$OleDbAdapter.Fill($DataTable)
$OleDbConn.close()

if(-not (Test-Path $destinationFolder)){

    New-Item -Path $destinationFolder -ItemType Directory -Force

}

foreach ($row in $DataTable.Rows){
   
   $code = $row.F3.ToString()
   
   if ($code -match '^\d{1,}$'){
  
       $imagePath = "$imageFolder\$code.jpg"

       if ($imagePath){
 
       Get-Item $imagePath -ErrorAction SilentlyContinue | Copy-Item -Destination $destinationFolder -ErrorAction SilentlyContinue -Force
       
       }
       
   }
}

Compress-Archive -Path "$destinationFolder*.jpg" -CompressionLevel Optimal -DestinationPath (Join-Path -Path $destinationFolder -ChildPath "image.zip")

Read-Host -Prompt "Press any key"