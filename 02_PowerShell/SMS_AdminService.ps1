$result = Invoke-RestMethod -Method Get -Uri 'https://sccm1.dev.lab/AdminService/v1.0/' -UseDefaultCredentials

$resultWMI = Invoke-RestMethod -Method Get -Uri "https://sccm1.dev.lab/AdminService/wmi/" -UseDefaultCredentials

Get-WmiObject -Namespace root\sms\site_Lab -Class SMS_ApplicationLatest -Filter "LocalizedDisplayname='7-zip'"


$appResult = Invoke-RestMethod -Method Get -Uri "https://sccm1.dev.lab/AdminService/wmi/SMS_ApplicationLatest?`$filterLocalizedDisplayName eq '7-zip'" -UseDefaultCredentials

$smsSite = [WMICLASS]"\\sccm1.dev.lab\root\sms\site_LAB:SMS_Site"

$params = $smsSite.GetMethodParameters('ImportMachineEntry')
$params.NetbiosName = 'MEMAutTest'
$params.MACAddress ='00-00-00-00-00-00'
$smsSite.InvokeMethod('ImportMachineEntry', $params, $null)


$body = @{NetbiosName='MEMAutTest' ; MACAddress = '00-00-00-00-00-00'} | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "https://sccm1.dev.lab/AdminService/wmi/SMS_Site.ImportMachineEntry" -Body $body -ContentType 'application/json' -UseDefaultCredentials

$collectioID = 'LAB00021'
    $body = @{
        "collectionRule" = @{
            "@odata.type"="#AdminService.SMS_CollectionRuleDirect";
            ResourceClassName="SMS_R_System";
            RuleName='TestAdminService';
            ResourceID=16777233
        }
    } | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri "https://sccm1.dev.lab/AdminService/wmi/SMS_Collection/$($CollectionID)/AdminService.AddMembershipRule" -Body $body -ContentType 'application/json' -UseDefaultCredentials

