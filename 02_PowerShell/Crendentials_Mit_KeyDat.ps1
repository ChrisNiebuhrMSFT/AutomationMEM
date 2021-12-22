
#Erzeugung einer Key.dat Datei
# Wir benötigen ein 16, 32, 64,... langen Schlüssel als Byte-Array [byte[]]

#region Dieser Abschnitt würde einmalig in einer separaten Datei liegen
#Testwort für die Erzeugung eines Schlüssels 
$keyDatData = 'PowerShellIsCool' # Als Beispiel wird hier ein 16 Zeichen langes Wort verwendet
#Byte-Array erzeugen
[byte[]]$keyData = $keyDatData.ToCharArray() | ForEach-Object {[byte]$_}
#Byte Array inklusive der TypInformation in die key.dat speichern. 
$keyData | Export-Clixml -Path $env:USERPROFILE\key.dat

#endregion 

#region Neue Datei Erstellung einer Passwort-Datei unter Verwendung einer Key.dat Datei

#Informationen aus der key.dat auslesen
[byte[]]$keyData = Import-Clixml -Path $env:USERPROFILE\key.dat

#Verschlüsseln des Passworts
$password = Read-Host -AsSecureString

#Password mit Hilfe des key.dat Schlüssels in einen Base64 String umwandeln
$pw64 = $password | ConvertFrom-SecureString -Key $keyData

#Custom Objekt erzeugen, welches von Gerät zu Gerät "geroamt" werden kann
$customCredentials = New-Object -TypeName PSObject -Property @{Username='beliebigerUser'; Password= $pw64}

$customCredentials | Export-Clixml -Path $env:userprofile\myCreds.xml
#endregion


#region Laden der Credentials von einem beliebigen System (myCreds.xml + key.dat müssen Zugreifbar sein)

$customCredentials = Import-Clixml -Path $env:userprofile\myCreds.xml
[byte[]]$keyData = Import-Clixml -Path $env:USERPROFILE\key.dat

#"Richtiges SecureStrig Password erzeugen
$password = $customCredentials.Password | ConvertTo-SecureString -Key $keyData

#Credential-Object erzeugen
$credentials = New-Object -TypeName PSCredential -ArgumentList @($customCredentials.Username, $password)
#endregion 