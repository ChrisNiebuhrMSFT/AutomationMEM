#region WMI Grundlagen und Tips
Get-CimClass -PropertyName UUID

Get-WmiObject -Class Win32_ComputerSystemProduct | Select *

Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -Property UUID


Get-CimClass -MethodName *domain*

$cs = Get-WmiObject -Class Win32_ComputerSystem 



Get-CimClass -MethodName *wins*

$nac = Get-WmiObject -Class Win32_NetworkAdapterConfiguration

$nac[2].SetWINSServer($null, $null) 

Get-CimClass -Namespace root\sms\site_LAB -PropertyName SDMPackageXML


Get-WmiObject -Class Win32_Process

Get-WmiObject -Query "Select * From Win32_Process"

#Worst Practise
Get-WmiObject -Class Win32_Process | Where-Object {$_.Name -eq 'notepad.exe'}


Get-WmiObject -Query "Select * From Win32_Process Where Name = 'notepad.exe'"


Get-WmiObject -Class Win32_Process -Filter "Name like 'notepad.exe'" # -Filter bei Get-WmiObject bezieht sich immer auf where Klausel in WQL

Get-WmiObject -Authentication PacketPrivacy #Kann gerade bei WMI Remoting helfen wenn Zugriff auf bestimmte Klasse / Namespace nicht funtkioniere bsp. CCM_Program / MS_ClusterResource


$app = Get-WmiObject -Namespace root\sms\site_Lab -Class SMS_ApplicationLatest -Filter "LocalizedDisplayname='7-zip'"

$app.Get() # Lazy Properties laden

$appCim = Get-CimInstance -Namespace root\sms\site_LAB -ClassName SMS_ApplicationLatest -Filter "LocalizedDisplayname='7-zip'"

$appCim = $appCim | Get-CimInstance # Lazy Properties via CIM laden

$appCim | Set-CimInstance 

#Umwandlung von WMI Zeit in Datetime
#Option 1
$d = $app.ConvertToDateTime($app.SummarizationTime)
#Option 2
[System.Management.managementdatetimeconverter]::ToDateTime($app.SummarizationTime)
#endregion 

#region Remoting

$computers = 'Win10client1', 'Win10Client2', 'Scor1'

foreach($computer in $computers)
{
    Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $computer
}


$result = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $computers



$osInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName Win10Client2 

$osInfoCim = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName Win10Client2 

$option = New-CimSessionOption -Protocol Dcom # 1.) Aktivieren der DCOM Kommunikation
$session = New-CimSession -SessionOption $option -ComputerName win10client2 # 2.) Konfiguration der Session

Get-CimInstance -CimSession $session -ClassName Win32_OperatingSystem #3 Verwendung


$remoteProc = Get-WmiObject -Class Win32_Process -ComputerName Win10Client2 -list 
$remoteProc.Create("powershell.exe -noprofile -executionpolicy bypass -command 'Enable-psRemoting -force'") 

# Implizites Remoting
$session = New-PSSession -ComputerName labdc 
Import-PSSession -Module ActiveDirectory -Session $session

#endregion 

#region Credential-Handling

#Never ever do this!!!!
$password = ConvertTo-SecureString -String "P@55w0rd" -AsPlainText -Force
$username = "Domain\DomAdmin"
$creds =  New-Object -TypeName System.Management.Automation.PsCredential -ArgumentList @($username, $password)


Get-Credential | Export-Clixml -Path $env:userprofile\desktop\creds.xml

#endregion 





