#region Zeichenketten in PowerShell

# Wir kennen PowerShell 3 Arten von Zeichenketten
 #1 Literal Strings
 #2 Expandable Strings
 #3 Here-Strings

 
 $zahl =5 

 Write-Host "Der Wert der Variable ist $zahl" #Expandable Strings

 Write-Host 'Der Wert der Variable ist $zahl' #Literal Strings

 $notepad = Get-Process -Name Notepad

 Write-Host "ProcessName : $notepad.Name - WorkingSet $notepad.WorkingSet" 

 Write-Host "ProcessName : $($notepad.Name) - WorkingSet $($notepad.WorkingSet)" 

 Write-Host "Ergebnis von 5 + 5 = $(5+5)"

Write-Host  ("ProcessName : {0} - WorkingSet {1:N2}MB" -f $notepad.Name, ($notepad.WorkingSet/1MB)) -ForegroundColor Green

65..98 | ForEach-Object {'{0} - {1} - 0x{2:X}' -f $_ , [char]$_, $_} 

1..500 | ForEach-Object {"TestWKS-{0:D5}" -f $_}


"Hallo `"Welt`"`n`t12345"


$here = @"
Hallo "Welt"
    12345

"@


# In here Strings ist kein Escaping erforderlich
$inputXML = @"
<Window x:Class="WpfApplication2.MainWindow"
 xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
 xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
 xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
 xmlns:local="clr-namespace:WpfApplication2"
 mc:Ignorable="d"
 Title="{0}" Height="416.794" Width="598.474" Topmost="True">
 <Grid Margin="0,0,45,0">
 </Grid>
</Window>
  
"@ -f "My CrazyWindow Title"

#endregion 

#region Zeichenketten Operationen (Vergleiche) 

'Hallo' -eq 'Hallo'

'Hallo' -eq 'hallo' # -eq unterscheidet keine Groß-Klein Schreibung

'Hallo' -ceq 'hallo'

'Hallo' -ceq 'Hallo'

'Hallo' -ieq 'hallo' # ieq und eq sind identisch 


'Hallo' -like "Hall*" #* gar nichts oder irgendwas beliebiges

'Hasakdsalkdjlksajdlksajdlksajdlksado' -like "Ha*o" 

'Hallo' -like 'H?ll?' # ? Genau ein beliebiges Zeichen

'Hello' -like 'H[ae]llo' # [] Character Sets => Menge an gültigen Zeichen


#Reguläre Ausdrücke (RegEx) 

'askdaslkjdlsakjdjlksajdhalloasldjölsajdlksajdlksajdsalkj' -match 'hallo'

'Halloaskdaslkjdlsakjdjlksajdasldjölsajdlksajdlksajdsalkj' -match '^hallo'

'askdaslkjdlsakjdjlksajdasldjölsajdlksajdlksajdsalkjhallo' -match 'hallo$'

'hallo' -match '^hallo$'

'salkjdsalkdjalksdjsalkdjsal123ödlföldskfsöldkfdsö' -match '[0123456789]'
'salkjdsalkdjalksdjsalkdjsal123ödlföldskfsöldkfdsö' -match '[0123456789]{3}'
'salkjdsalkdjalksdjsalkdjsal123777777ödlföldskfsöldkfdsö' -match '[0123456789]{1,3}'
'salkjdsalkdjalksdjsalkdjsal1234dlföldskfsöldkfdsö' -match '[a-z][0123456789]{1,3}[a-z]'

'salkjdsalkdjalksdjsalkdjsal123777777ödlföldskfsöldkfdsö' -match '[0-9]{1,3}'
'salkjdsalkdjalksdjsalkdjsal123777777ödlföldskfsöldkfdsö' -match '\d{1,3}'

'salkjdsalkdjalksdjsalkdjsal39475984375984375984375984375ödlföldskfsöldkfdsö' -match '\d{0,}'
'salkjdsalkdjalksdjsalkdjsal39475984375984375984375984375ödlföldskfsöldkfdsö' -match '\d*' # \d{0,}
'salkjdsalkdjalksdjsalkdjsal39475984375984375984375984375ödlföldskfsöldkfdsö' -match '\d{1,}'
'salkjdsalkdjalksdjsalkdjsal39475984375984375984375984375ödlföldskfsöldkfdsö' -match '\d+' #\d{1,}

'VW Golf' -match 'VW (Golf|Polo)'

'VW Polo' -match 'VW (Golf|Polo)'

'VW Passat' -match 'VW (Golf|Polo)'

# Mein Computername beginnt mit PC-DE-DEV-12345
# PC-{DEU,AUT,POL,DAN}-{DEV,WKS}-12345

#Naiver Ansatz
$computerName = 'PC-POL-DEV-12345'

$parts = $computerName -split '-'

if($parts[0] -eq 'PC' -and $parts[1] -in @('DEU', 'AUT', 'POL', 'DAN'))
{
    'jo'
}

#RegEx Ansatz

if($computerName -match '^PC-(DEU|AUT|POL|DAN|IT)-(WKS|DEV)-\d{5}$')
{
    'jo'
}

'hallo' -match '\w+'

'chris.niebuhr@mail.com' -match '\w+\.\w+@\w+\.\w+'

'chris.niebuhr@mail.com' -match '(\w+)\.(\w+)@(\w+)\.(\w+)'

$vorname  = $Matches[1]
$nachname = $Matches[2]
'chris.niebuhr@mail.com' -match '(?<Vorname>\w+)\.(?<Nachname>\w+)@(?<Provider>\w+)\.(?<Domain>\w+)'
$Matches.Vorname
$Matches.Domain


$data= 'niebuhr,chris'

$splits = $data -split ','

'{0}-{1}' -f $splits[1], $splits[0]


$data -replace '(\w+),(\w+)', '$2-$1'

'niebuhr chris 001' -replace '(\w+) (\w+) (\d{3})', '$3---$2:$1'


$computers = Get-content -Path "C:\Users\chnieb\OneDrive - Microsoft\Desktop\Computers.txt"
foreach($computer in $computers)
{
    if($computer -match '^PC-(DEU|AUT|POL|DAN|IT)-(WKS|DEV)-\d{5}$')
    {
        Write-Host "$computer entspricht der Namenskonvention" -ForegroundColor Green
    }
    else
    {
        Write-Host "$computer entspricht NICHT der Namenskonvention" -ForegroundColor YELLOW
    }
}


switch -Regex -File "C:\Users\chnieb\OneDrive - Microsoft\Desktop\Computers.txt"
{
    '^PC-(DEU|AUT|POL|DAN|IT)-(WKS|DEV)-\d{5}$' {Write-Host "$_ entspricht der Namenskonvention" -ForegroundColor Green}
    'DEU' {Write-Host "$_ kommt aus Deutschland"}
    default {Write-Host "$_ entspricht NICHT der Namenskonvention" -ForegroundColor YELLOW}
}

$str = 'Pano'

switch ($str)
{
    {$str.Length -eq 4} {"Moin Pano"}
}

#endregion 

