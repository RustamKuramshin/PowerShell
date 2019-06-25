Import-Module ActiveDirectory

$date_offset = (Get-Date).AddDays(-180) # 180 дней назад

Get-ADUser -Properties LastLogonDate -Filter {LastLogonDate -lt $date_offset } | Sort LastLogonDate

Read-Host