$tenantID = '245dd393-7eb7-418a-a2eb-90e17ede7cc2'
$clientID = 'fa864478-4d6d-44b9-8901-c96366465e78'
$clientSecret = 'xgK7Q~rkNdMbaAN~YsZgEeHkY~IQUdl-F99YD'

$body = @{
    'tenant' = $tenantID
    'client_id' = $clientID
    'scope' = 'https://graph.microsoft.com/.default'
    'client_secret' = $clientSecret
    'grant_type' = 'client_credentials'
}
$params =@{
    'Uri' = "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token"
    'Method' = 'Post'
    'Body' = $body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$response = Invoke-RestMethod @params

$Headers = @{
    'Authorization' = "Bearer $($response.access_token)"
}

<#
POST /users/{usersId}/managedDevices/{managedDeviceId}/syncDevice
POST /deviceManagement/managedDevices/{managedDeviceId}/syncDevice
POST /deviceManagement/detectedApps/{detectedAppId}/managedDevices/{managedDeviceId}/syncDevice
#>

$users  = Invoke-RestMethod -Headers $Headers -Method Get -Uri 'https://graph.microsoft.com/v1.0/users'
$result = Invoke-RestMethod -Headers $Headers -Method Get -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices'
$result = Invoke-RestMethod -Headers $Headers -Method Get -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/{99f34d57-c7d7-4148-a05a-d99ee460f4ec}'

$result = Invoke-RestMethod -Headers $Headers -Method Post -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/{99f34d57-c7d7-4148-a05a-d99ee460f4ec}/syncDevice'


$deviceIDs = $result.value | Select-Object -ExpandProperty ID

foreach($deviceID in $deviceIDs)
{
    $syncDeviceURL = 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/{{{0}}}/syncDevice' -f $deviceID
    $result = Invoke-RestMethod -Headers $Headers -Method Post -Uri $syncDeviceURL
}