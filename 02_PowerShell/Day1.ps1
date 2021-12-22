$p = Get-WmiObject -Class Win32_Process -Filter "Name='notepad.exe'" #Notepad Prozess abfragen

$proc = Get-WmiObject -Class Win32_Process -list 
$proc.Create("notepad.exe")

Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList @("notepad.exe")

[Math]::abs(-4) # Zugriff auf statische Member erfolgt in PowerShell immer über :: 

#Von Viktor Erklärung 
$WMIPath = [WmiClass]"ROOT\cimv2:Win32_Process"
$inParams = $WMIPath.GetMethodParameters('Create')
$inParams.CommandLine = 'notepad.exe'
$notepad = $WMIPath.InvokeMethod('Create', $inParams, $NULL)


$arr = 1..10

$arr.Where({$_ -gt 5}) #Where Methode zum Filtern verwenden


[string]$str = 'Mein Test'

$myArr = 1,'Chris', (Get-process) #Arrays in PowerShell sind per Default Object[] 

$myArr.GetType()

[Uint32[]]$intArr = 1,2,3,4,'hallo'


#Ganz häufig kapselt PowerShell nur Funktionalitäten aus dem .NEt Framework oder WMI
$procs = Get-Process
[System.Diagnostics.Process]::GetProcesses()

Get-Date
[System.DateTime]::Now

Get-HotFix
Get-WmiObject -Class Win32_QuickfixEngineering

Test-Connection -ComputerName google.de
Get-WmiObject -Query "Select * From Win32_PingStatus where Address='google.de'"

#Einsatzbeispiel für ExtentionMethods in PowerShell
$bigger, $smaller = (1..10).where({$_ -ge 5}, 'Split') 


$arr = get-service

if($arr -is [System.Object])
{
    "jo"
}




# Mit -is kann auf Datentypen geprüft werden
[int32[]]$intarr = 1,2,3,4,5

[string[]]$strArr = 'Hallo', 'Welt'

$intArr -is [Array]

$strArr -is [Array]

$strArr -is [int32[]]

$myArr -is [string[]]


$i = 1
Write-Host (++$i) 

$i 



#Verwendung .Net Delegates in PowerShell
$func1 = [func[int32, bool]]{param($a) return $a -gt 5}
$func1.Invoke(6) 


$add = [func[int32, int32, int32]]{param($a, $b) return $a +$b}
$sub = [func[int32, int32, int32]]{param($a, $b) return $a -$b}
$mult = [func[int32, int32, int32]]{param($a, $b) return $a *$b}
$div = [func[int32, int32, int32]]{param($a, $b) return $a /$b}

$funcArr = @($add, $sub, $mult, $div)

foreach($f in $funcArr)
{
    $f.Invoke(10,5)
}

