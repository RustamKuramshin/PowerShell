﻿$SQLServer =  # IP-адрес SQL Server
$SQLDBName = ""
$uid = ""
$pwd =""
$SqlQuery = "SELECT TOP (10) trade_test.dbo.SC33.[DESCR], trade_test.dbo.SC33.[CODE] FROM SC33"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; User ID = $uid; Password = $pwd;"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

$DataSet.Tables[0] | out-file "" # Путь к файлу
$SqlConnection.Close()