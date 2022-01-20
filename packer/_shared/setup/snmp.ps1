Import-Module -Name 'NetSecurity'

# Setup windows update service to manual
$wuauserv = Get-WmiObject Win32_Service -Filter "Name = 'wuauserv'"
$wuauserv_starttype = $wuauserv.StartMode
Set-Service wuauserv -StartupType Manual

# Install OenSSH
Add-WindowsCapability -Online -Name "SNMP.Client~~~~0.0.1.0"

# Setup windows update service to original
Set-Service wuauserv -StartupType $wuauserv_starttype

netsh advfirewall firewall add rule name="SNMP UDP Port 161 In" dir=in action=allow protocol=UDP localport=161
netsh advfirewall firewall add rule name="SNMPTRAP UDP Port 162 In" dir=in action=allow protocol=UDP localport=162
netsh advfirewall firewall add rule name="SNMP UDP Port 161 Out" dir=out action=allow protocol=UDP localport=161
netsh advfirewall firewall add rule name="SNMPTRAP UDP Port 162 Out" dir=out action=allow protocol=UDP localport=162
