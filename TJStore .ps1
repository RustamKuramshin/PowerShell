Clear-Host

Get-ChildItem -Recurse -Filter *.log | Get-Content | Add-Content -Path ".\TJStore $(Get-Date -Format yyyy-MM-ddTHH-mm-ss-ff).txt" -Encoding Unicode