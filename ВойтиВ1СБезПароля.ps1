function Invoke-SQL {
    param(
        [string]$dataSource = ".\SQLEXPRESS",
        [string]$database = "MasterData",
        [string]$sqlCommand = $(throw "Please specify a query."),
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    if ($Credential -ne [System.Management.Automation.PSCredential]::Empty) {
        $connectionString = "Server=$dataSource;Database=$database;User Id=$($Credential.UserName);Password=$($Credential.GetNetworkCredential().password);"
    } else {
        $connectionString = "Data Source=$dataSource; Integrated Security=SSPI; Initial Catalog=$database"
    }

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()
    
    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null
    
    $connection.Close()
       
}

Read-Host -Prompt 'ВАЖНО! УБЕДИТЕСЬ, ЧТО С БАЗОЙ 1С СЕЙЧАС НИКТО НЕ РАБОТАЕТ! НАЖМИТЕ ENTER!'

$username = Read-Host "Имя пользователя SQL Server"
$password = Read-Host "Введите пароль" -AsSecureString
$address  = Read-Host "Имя\адрес СУБД SQL Server"
$dbName   = Read-Host "Имя базы данных"

Test-Connection -ComputerName $address -Count 1 -ErrorAction Stop | Out-Null

$sqlUserCred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $username,$password

$sqlQuery = @"
EXEC sp_rename 'v8users', 'v8users_tmp'
UPDATE [Params]
SET [FileName] = 'users.usr_tmp'
WHERE [FileName] = 'users.usr'
"@

Invoke-SQL -dataSource $address -database $dbName -sqlCommand $sqlQuery -Credential $sqlUserCred

Read-Host "Зайдите в конфигуратор, вернитесь в консоль PowerShell и нажмите Enter"

$sqlQuery = @"
DROP TABLE [v8users]
EXEC sp_rename 'v8users_tmp', 'v8users'
UPDATE [Params]
SET FileName = 'users.usr'
WHERE FileName = 'users.usr_tmp'
"@

Invoke-SQL -dataSource $address -database $dbName -sqlCommand $sqlQuery -Credential $sqlUserCred

Read-Host "Измените пароль в конфигураторе, вернитесь в консоль PowerShell и нажмите Enter"