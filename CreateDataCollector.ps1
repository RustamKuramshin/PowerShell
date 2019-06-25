<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.144
	 Created on:   	07.01.2019 19:22
	 Created by:   	Cat
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#Functions start here.
Function CheckCollector([System.Object]$DCS, [string]$DCName)
{
	# Check if the data collector exists in the DataCollectorSet
	If (($DCS.DataCollectors | Select Name) -match $DCName)
	{ Return $true }
	ELSE
	{ Return $false }
}

Function CreateCollectorServer([System.Object]$DCS, [string]$DCName)
{
	$XML = Get-Content $ScriptDir\SQLAudit-Server.xml
	$DC = $DCS.DataCollectors.CreateDataCollector(0)
	$DC.Name = $DCName
	$DC.FileName = $DCName + "_";
	$DC.FileNameFormat = 0x0003;
	$DC.FileNameFormatPattern = "yyyyMMddHHmm";
	$DC.SampleInterval = 15;
	$DC.LogFileFormat = 0x0003;
	$DC.SetXML($XML);
	$DCS.DataCollectors.Add($DC)
}

Function CreateCollectorInstance([System.Object]$DCS, [string]$DCName, [string]$ReplaceString)
{
	$XML = (Get-Content $ScriptDir\SQLAudit-Instance.xml) -replace "%instance%", $ReplaceString
	$DC = $DCS.DataCollectors.CreateDataCollector(0)
	$DC.Name = $DCName
	$DC.FileName = $DCName + "_";
	$DC.FileNameFormat = 0x0003;
	$DC.FileNameFormatPattern = "yyyyMMddHHmm";
	$DC.SampleInterval = 15;
	$DC.LogFileFormat = 0x0003;
	$DC.SetXML($XML);
	$DCS.DataCollectors.Add($DC)
}
Function CommitChanges([System.Object]$DCS, [string]$DCSName)
{
	$DCS.Commit($DCSName, $Server, 0x0003) | Out-Null
	$DCS.Query($DCSName, $Server) #refresh with updates.
}

Function Get-SqlInstances
{
	Param ($Server = $env:ComputerName)
	
	$Instances = @()
	[array]$captions = gwmi win32_service -computerName $Server | ?{ $_.Caption -match "SQL Server*" -and $_.PathName -match "sqlservr.exe" } | %{ $_.Caption }
	foreach ($caption in $captions)
	{
		if ($caption -eq "MSSQLSERVER")
		{
			$Instances += "MSSQLSERVER"
		}
		else
		{
			$Instances += $caption | %{ $_.split(" ")[-1] } | %{ $_.trimStart("(") } | %{ $_.trimEnd(")") }
		}
	}
	$Instances
}

Param (
	#default to the current server. Can be a remote server.
	[string]$Server = $env:ComputerName,
	#if this switch is used, the Data Collectors will be cleared, and new ones created based on the SQLAudit-Server / SQLAudit-Instance XML files.

	[switch]$updateDC
)

## Script starts here ##
$DCSName = "SQLAudit"; #Set this to what you want the Data Collector Set to be called.
Write-Host "Running Perfmon-Collector to create / update Perfmon Data Collector Set $DCSName on $Server" -ForegroundColor Green
#Directory for the output Perfmon files.
$SubDir = "C:\PerfMon\PerfmonLogs"
# Location of the Scripts/Files. SQLAudit-Server.XML, SQLAudit-Instance.XML
$ScriptDir = "C:\Scripts"

# Create directories if they do not exist.
Invoke-Command -ComputerName $Server -ArgumentList $SubDir, $ScriptDir -ScriptBlock {
	param ($SubDir,
		$ScriptDir)
	If (!(Test-Path -PathType Container $SubDir))
	{
		New-Item -ItemType Directory -Path $SubDir | Out-Null
	}
	If (!(Test-Path -PathType Container $ScriptDir))
	{
		New-Item -ItemType Directory -Path $ScriptDir | Out-Null
	}
}

# DataCollectorSet Check and Creation
$DCS = New-Object -COM Pla.DataCollectorSet

try # Check to see if the Data Collector Set exists
{
	$DCS.Query($DCSName, $Server)
}
# Need to catch both exceptions. Different O/S have different exceptions.
catch [System.Management.Automation.MethodInvocationException], [System.Runtime.InteropServices.COMException]
{
	Write-Host "Creating the $DCSName Data Collector Set" -ForegroundColor Green
	$DCS.DisplayName = $DCSName;
	$DCS.Segment = $true;
	$DCS.SegmentMaxDuration = 86400; # 1 day duration
	$DCS.SubdirectoryFormat = 1; # empty pattern, but use the $SubDir
	$DCS.RootPath = $SubDir;
	
	try #Commit changes
	{
		CommitChanges $DCS $DCSName
		
		Invoke-Command -ComputerName $Server -ArgumentList $DCSName -ScriptBlock {
			param ($DCSName)
			$Trigger = @()
			#Start when server starts.
			$Trigger += New-ScheduledTaskTrigger -AtStartup
			#Restart Daily at 5AM. Note: I have not used Segments.
			$Trigger += New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday -at 05:00
			$Path = (Get-ScheduledTask -TaskName $DCSName).TaskPath
			#This setting in the Windows Scheduler forces the existing Data Collector Set to stop, and a new one to start
			$StopExisting = New-ScheduledTaskSettingsSet
			$StopExisting.CimInstanceProperties['MultipleInstances'].Value = 3
			Set-ScheduledTask -TaskName $DCSName -TaskPath $Path -Trigger $Trigger -Settings $StopExisting | Out-Null
		}
		$DCS.Query($DCSName, $Server) #refresh with updates.
	}
	catch
	{
		Write-Host "Exception caught: " $_.Exception -ForegroundColor Red
		return
	}
}

#If updateDC parameter is supplied, Stop the existing data collectors and clear the data collectors from the data collector set.

If ($updateDC)
{
	If ($DCS.Status -ne 0)
	{
		try
		{
			$DCS.Stop($true)
		}
		Catch
		{
			Write-Host '-updateDC parameter was supplied but collectors did not stop successfully. Script exiting.' -ForegroundColor Red
			Exit 1
		}
	}
	$DCS.DataCollectors.Clear()
	CommitChanges $DCS $DCSName
}

#DataCollector - SQLAudit-Server
$DCName = "$DCSName-Server";

# If the Data Collector does not exist, create it!
If (!(CheckCollector $DCS $DCName))
{
	Write-Host "Creating the $DCName Data Collector in the $DCSName Data Collector Set" -ForeGroundColor Green
	CreateCollectorServer $DCS $DCName
	CommitChanges $DCS $DCSName
}

#Data Collector - SQLAudit-Instances. Loop through installed instances and create collector for each if they do not exist.
$Instances = Get-SQLInstances -Server $Server

foreach ($Instance in $Instances)
{
	If ($Instance -eq "MSSQLSERVER")
	{
		$ReplaceString = "SQLServer";
	}
	ELSE
	{
		$ReplaceString = "MSSQL`$$Instance";
	}
	$DCName = "$DCSName-$Instance";
	
	If (!(CheckCollector $DCS $DCName))
	{
		Write-Host "Creating the $DCName Data Collector in the $DCSName Data Collector Set" -ForeGroundColor Green
		CreateCollectorInstance $DCS $DCName $ReplaceString
		CommitChanges $DCS $DCSName
	}
}

# Start the data collector set.
try
{
	
	If ($DCS.Status -eq 0)
	{
		$DCS.Start($true)
		Write-Host "Successfully created $DCSName and started the collectors." -ForeGroundColor Green
	}
}
catch
{
	Write-Host "Exception caught: " $_.Exception -ForegroundColor Red
	return
}