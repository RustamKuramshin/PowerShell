
$colSlots = Get-WmiObject -Class "win32_PhysicalMemoryArray" -namespace "root\CIMV2" 

$colRAM = Get-WmiObject -Class "win32_PhysicalMemory" -namespace "root\CIMV2" 


Foreach ($objSlot In $colSlots){
     "Total Number of DIMM Slots: " + $objSlot.MemoryDevices
}
Foreach ($objRAM In $colRAM) {
     "Memory Installed: " + $objRAM.DeviceLocator
     "Memory Size: " + ($objRAM.Capacity / 1GB) + " GB"
}
Read-Host