#region Helper Classes

enum ApprovalState
{
    Waiting = 0
    Declined = 1
    Approved = 3
}

class MECMProviderHelper
{
    [string]
    $SiteCode
    [string]
    $Namespace
    [string]
    $Machine
    [Version]
    $SiteVersion

    MECMProviderHelper([string]$MECMProviderName)
    {
       $this.InitObject($MECMProviderName)
    }

    MECMProviderHelper()
    {
        $this.InitObject($env:COMPUTERNAME)
    }

    hidden [void] InitObject([string]$MECMProviderName)
    {
        try
        {
            $tmpResult        = Get-WmiObject -ComputerName $MECMProviderName -Namespace root\sms -Class SMS_Providerlocation -Filter "ProviderForLocalSite=True" -ErrorAction Stop | Select-Object -First 1
            $this.SiteCode    = $tmpResult.SiteCode
            $this.Namespace   = $tmpResult.NamespacePath -replace '\\\\.+?\\', '' #Parse "Namespace-Only"
            $this.Machine     = $tmpResult.Machine
            $this.SiteVersion = [Version](Get-WmiObject -ComputerName $MECMProviderName -Namespace $this.Namespace -Class SMS_Site).Version
        }
        catch
        {
            throw $_
        }
    }
}

class MECMScripts
{
    [System.Management.ManagementObject[]]
    $Scripts
    hidden [MECMProviderHelper]$MECMProviderHelper

    MECMSCripts([MECMProviderHelper]$mecmProvider)
    {
        $tmpScripts   = Get-WmiObject -ComputerName $mecmProvider.Machine -Namespace $mecmProvider.Namespace -Class SMS_Scripts -Filter "ScriptName <> 'CMPivot'" 
        $this.Scripts = $tmpScripts | ForEach-Object {$_.Get(); $_} #Load-Lazy Properties (incl. Scriptcontent)
        $this.MECMProviderHelper = $mecmProvider
    }

    hidden [string]ConvertFromBase64([string]$Base64Content)
    {
         $tmpArr = [System.Convert]::FromBase64String($Base64Content)
         return [System.Text.Encoding]::Unicode.GetString($tmpArr)    
    }

    [bool]TestScriptExists([string]$Scriptname, [string]$Version)
    {
        $scriptResult = (Get-WmiObject -ComputerName $this.MECMProviderHelper.Machine -Namespace $this.MECMProviderHelper.Namespace -Class SMS_Scripts -Filter "ScriptName='$Scriptname' AND ScriptVersion=$Version" )
        return ($null -ne $scriptResult)
    }

    [void]BackupScripts([string]$BackupPath)
    {
        Write-Host '============== Started Scriptbackup =============='

        if(-not (Test-Path -Path $BackupPath))
        {
            Write-Host "Creating folder: $BackupPath" -ForegroundColor Green
            $null = New-Item -Path $BackupPath -ItemType Directory
       }
        foreach($script in $this.Scripts)
        {
            $scriptContent  = $this.ConvertFromBase64($script.Script)
            $invalidChars = '\*|\?|\\|/'
            $normalizedName = $script.ScriptName -replace $invalidChars, ''
            $normalizedPath = [System.IO.Path]::Combine($BackupPath, $normalizedName)
            $fileName = ('{0}_v{1}.ps1' -f $normalizedPath, $script.Scriptversion)
            Write-Host 'Backup Script ' -NoNewline
            Write-Host ('{0}' -f $script.ScriptName) -NoNewline -ForegroundColor Green
            Write-Host ' under ' -NoNewline 
            Write-Host ('{0}' -f $fileName) -ForegroundColor Green

            $scriptContent.Substring(1) | Out-File -FilePath $fileName -Encoding default
        }
        $BackupXMLPath = [System.IO.Path]::Combine($BackupPath, 'BackupXML')
        if(-not (Test-Path -Path $BackupXMLPath))
        {
            Write-Host "Creating folder: $BackupXMLPath" -ForegroundColor Green
            $null = New-Item -Path $BackupXMLPath -ItemType Directory
        }
        $this.Scripts | Export-Clixml -Path ([System.IO.Path]::Combine($BackupXMLPath, ('Scriptbackup_{0}.xml' -f (Get-Date -Format 'yy_MM_dd'))))
        Write-Host '============== Finished Scriptbackup ==============' 
    }

    [void]ImportScripts([string]$BackupPath)
    {
        Write-Host '============== Started Scriptimport =============='

        if(Test-Path -Path $BackupPath)
        {
            $files = Get-ChildItem -File -Path $BackupPath -Filter 'Scriptbackup*.xml'

            if($files)
            {
                $selection = $files | Out-GridView -Title 'Select Backupfile to restore' -OutputMode Single 
                if($selection)
                {
                    $scriptManager = [MECMScriptManager]::new($this.MECMProviderHelper)
                    $scriptData = Import-Clixml -Path $selection.Fullname
                    foreach($script in $scriptData)
                    {
                        if($this.TestScriptExists($script.ScriptName, $script.ScriptVersion))
                        {
                            Write-Host ('Script {0} already exists and will be skipped' -f $script.ScriptName) -ForegroundColor Yellow
                        }
                        else
                        {
                            Write-Host 'Importing Script '-NoNewline
                            Write-Host $script.Scriptname -ForegroundColor Green
                            $scriptManager.CreateScriptFromBase64($script.Scriptname, $script.ScriptVersion, $script.Description, $script.Comment, [ApprovalState]::Approved, $Script.Script)
                            
                            
                        }
                    }
                }
                else
                {
                    Write-Host 'No Backupfile was selected' -ForegroundColor Yellow
                }
            }
            else
            {
                Write-Host 'No Backupfile found' -ForegroundColor Yellow
                return
            }
            
            Write-Host '============== Finished Scriptimport ==============' 
         }
         else
         {
            Write-Host "Backuppath: $BackupPath does not exist" -ForegroundColor Yellow
         }
       
    }
}

class MECMScriptManager
{
    hidden [MECMProviderHelper]$MECMProviderHelper
    hidden [System.Management.ManagementClass]$ScriptManager
    MECMScriptManager([MECMProviderHelper]$mecmProvider)
    {
        $this.MECMProviderHelper = $mecmProvider
        $this.ScriptManager = Get-WmiObject -ComputerName $mecmProvider.Machine -Class SMS_Scripts -Namespace $mecmProvider.Namespace -List
    }

    hidden [string]ConvertToBase64([string]$Content)
    {
        $tmpArr = [System.Text.Encoding]::UTF8.GetBytes($Content)
        return [System.Convert]::ToBase64String($tmpArr)
    }

    [void]CreateScriptFromBase64([string]$ScriptName, [string]$scriptVersion, [string]$Description,[string]$Comment, [ApprovalState]$ApprovalState, [string]$ScriptContent)
    {
        try 
        {
            if($this.MECMProviderHelper.SiteVersion.Build -lt 9078)
            {
                $this.ScriptManager.CreateScripts((New-Guid).Guid, $scriptVersion, $ScriptName, [string]::Empty, [Uint32]0, [Uint32]0, [string]::Empty, $Comment, [string]::Empty, [string]::Empty,$ScriptContent)
            }
            else
            {
                $this.ScriptManager.CreateScripts((New-Guid).Guid, $scriptVersion, $ScriptName, $Description, [string]::Empty, [Uint32]0, [Uint32]0, [string]::Empty, $Comment, [string]::Empty, [string]::Empty,$ScriptContent)   
            }
            $tmpScript = Get-WmiObject -ComputerName $this.MECMProviderHelper.Machine -Namespace $this.MECMProviderHelper.Namespace -Class SMS_Scripts -Filter "ScriptName='$ScriptName' AND ScriptVersion=$ScriptVersion" 
            $tmpScript.UpdateApprovalState($ApprovalState.value__, [String]::Empty, $Comment)
        }
        catch
        {
            throw $_
        }
    }

    [void]CreateScriptFromPlainText([string]$ScriptName, [string]$scriptVersion, [string]$Description,[string]$Comment, [ApprovalState]$ApprovalState, [string]$ScriptContent)
    {
        try 
        {
            $content = $this.ConvertToBase64($ScriptContent)
            if($this.MECMProviderHelper.SiteVersion.Build -lt 9078) #CreateScripts Method was changed in Version 9078 (added Description Parameter)
            {
                $this.ScriptManager.CreateScripts((New-Guid).Guid, $scriptVersion, $ScriptName, [string]::Empty, [Uint32]0, [Uint32]0, [string]::Empty, $Comment, [string]::Empty, [string]::Empty,$content)
            }
            else
            {
                $this.ScriptManager.CreateScripts((New-Guid).Guid, $scriptVersion, $ScriptName, $Description, [string]::Empty, [Uint32]0, [Uint32]0, [string]::Empty, $Comment, [string]::Empty, [string]::Empty,$content)   
            }
           
            $tmpScript = Get-WmiObject -ComputerName $this.MECMProviderHelper.Machine -Namespace $this.MECMProviderHelper.Namespace -Class SMS_Scripts -Filter "ScriptName='$ScriptName' AND ScriptVersion=$ScriptVersion"
            $tmpScript.UpdateApprovalState($ApprovalState.value__, [String]::Empty, $Comment)
        }
        catch
        {
            throw $_
        }
    }

    [void]RenameScript([string]$ScriptName, [string]$NewScriptName)
    {
        $tmpScript = Get-WmiObject -ComputerName $this.MECMProviderHelper.Machine -Namespace $this.MECMProviderHelper.Namespace -Class SMS_Scripts -Filter "ScriptName='$ScriptName'"
        if($tmpScript)
        {
            $tmpScript.Get()
            $newVersion = [Convert]::ToInt32($tmpScript.ScriptVersion) + 1
            $this.CreateScriptFromBase64($NewScriptName, $newVersion, $tmpScript.ScriptDescription, $tmpScript.Comment, [Approvalstate]::Approved, $tmpScript.Script)
            $tmpScript | Remove-WmiObject 
            Write-Host "Script " -NoNewline
            Write-Host "$ScriptName " -NoNewline -ForegroundColor Green
            Write-Host "successfully renamed to " -NoNewline 
            Write-Host "$NewScriptName" -ForegroundColor Green
        }
        else
        {
            Write-Host "Script $ScriptName could not be found" -ForegroundColor Yellow
        }
    }
}

#endregion


#region Main-Logic
$mecmProvider  = [MECMProviderHelper]::new()
$cmScripts     = [MECMScripts]::new($mecmProvider)
$scriptManager = [MECMScriptManager]::new($mecmProvider)

$cmScripts.BackupScripts('E:\ScriptBackup')
#$cmScripts.ImportScripts('D:\CUSTOM\bin\Tools\CMScriptManager\Backup\BackupXML')
#$scriptManager.RenameScript('SI-Get-IP', 'Get-IPAddress')
#endregion 



