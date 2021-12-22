Connect-AzAccount 

#Get-AzAutomationHybridWorkerGroup -AutomationAccountName labautomation -ResourceGroupName azautomation 
function Invoke-Runbook
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [string]
        $AutomationAccountName, 
        [string]
        $RunBookname, 
        [string]
        $Worker,
        [HashTable]
        $RunBookParams
    )

    $resourceGroup = Get-AzResource -Name $AutomationAccountName | Select-Object -ExpandProperty ResourceGroupName
    $splat = @{Name = $RunBookname ;Parameters = $RunBookParams ;ResourceGroupName  = $resourceGroup ;AutomationAccountName = $AutomationAccountName ;Wait = $true}
    if($Worker)
    {
        $job = Start-AzAutomationRunbook @splat -RunOn $Worker 
    }
    else
    {
        $job = Start-AzAutomationRunbook @splat
    }
    $job
    #Get-AzAutomationJobOutput -Id $job.JobId -ResourceGroupName $resourceGroup -AutomationAccountName $AutmationAccountName 
}

Invoke-Runbook -AutomationAccountName AzureAutomation -RunBookname 'MEMAutomation' -RunBookParams @{DeviceName = 'MECMTest1'; UUID='00000000000000000000000000000001'} -Worker 'HybridWorkerCNI'

