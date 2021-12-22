﻿#region Umgang mit Rest-API

$json = @"
{
    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
    "businessPhones": [],
    "displayName": "Lab Admin",
    "givenName": "Lab",
    "jobTitle": null,
    "mail": "labadmin@azure.chnieb.de",
    "mobilePhone": null,
    "officeLocation": null,
    "preferredLanguage": null,
    "surname": "Admin",
    "userPrincipalName": "labadmin@azure.chnieb.de",
    "id": "766e759a-4239-43ac-874b-172cf4c48020"
}
"@

$jsonObj = $json | ConvertFrom-Json

$body = @"
{
    "deviceName" : "MyNewName"
}
"@

$testData = @{
deviceName= 'MyNewName'
dataArray = 'PowerShell', 'Rockz'
}

$jsonData = $testData | ConvertTo-Json


$header = @{
'Authorization' = 'Bearer  {0}' -f 'eyJ0eXAiOiJKV1QiLCJub25jZSI6IkRVR25LSUhLdmVLNlVTNTZ4aHFva3hMWF9mc3dSS0wzemlkb0hnblhZSjAiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1yNS1BVWliZkJpaTdOZDFqQmViYXhib1hXMCIsImtpZCI6Ik1yNS1BVWliZkJpaTdOZDFqQmViYXhib1hXMCJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8yNDVkZDM5My03ZWI3LTQxOGEtYTJlYi05MGUxN2VkZTdjYzIvIiwiaWF0IjoxNjQwMTY2NTYxLCJuYmYiOjE2NDAxNjY1NjEsImV4cCI6MTY0MDE3MjEzMCwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkUyWmdZS2pjZnozYlNsT0R3VXZaeStiSzVWeXArb3BQU3l2RVgvMTNXRlhPUE1HR1J4SUEiLCJhbXIiOlsicHdkIl0sImFwcF9kaXNwbGF5bmFtZSI6IkdyYXBoIEV4cGxvcmVyIiwiYXBwaWQiOiJkZThiYzhiNS1kOWY5LTQ4YjEtYThhZC1iNzQ4ZGE3MjUwNjQiLCJhcHBpZGFjciI6IjAiLCJmYW1pbHlfbmFtZSI6IkFkbWluIiwiZ2l2ZW5fbmFtZSI6IkxhYiIsImlkdHlwIjoidXNlciIsImlwYWRkciI6Ijc5LjIxNi4zOC4yMzAiLCJuYW1lIjoiTGFiIEFkbWluIiwib2lkIjoiNzY2ZTc1OWEtNDIzOS00M2FjLTg3NGItMTcyY2Y0YzQ4MDIwIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTI1NzE4MjA2ODEtMTYzNzI2MTc5OC00MDY3MzM5NDA5LTExMDciLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDE4REU2QkFFRSIsInJoIjoiMC5BUzhBazlOZEpMZC1pa0dpNjVEaGZ0NTh3clhJaTk3NTJiRklxSzIzU05weVVHUXZBRmsuIiwic2NwIjoiQ2FsZW5kYXJzLlJlYWRXcml0ZSBDaGF0LlJlYWQgQ2hhdC5SZWFkQmFzaWMgQ29udGFjdHMuUmVhZFdyaXRlIERldmljZU1hbmFnZW1lbnRSQkFDLlJlYWQuQWxsIERldmljZU1hbmFnZW1lbnRTZXJ2aWNlQ29uZmlnLlJlYWQuQWxsIEZpbGVzLlJlYWRXcml0ZS5BbGwgR3JvdXAuUmVhZFdyaXRlLkFsbCBJZGVudGl0eVJpc2tFdmVudC5SZWFkLkFsbCBNYWlsLlJlYWQgTWFpbC5SZWFkV3JpdGUgTWFpbGJveFNldHRpbmdzLlJlYWRXcml0ZSBOb3Rlcy5SZWFkV3JpdGUuQWxsIG9wZW5pZCBQZW9wbGUuUmVhZCBQbGFjZS5SZWFkIFByZXNlbmNlLlJlYWQgUHJlc2VuY2UuUmVhZC5BbGwgUHJpbnRlclNoYXJlLlJlYWRCYXNpYy5BbGwgUHJpbnRKb2IuQ3JlYXRlIFByaW50Sm9iLlJlYWRCYXNpYyBwcm9maWxlIFJlcG9ydHMuUmVhZC5BbGwgU2l0ZXMuUmVhZFdyaXRlLkFsbCBUYXNrcy5SZWFkV3JpdGUgVXNlci5SZWFkIFVzZXIuUmVhZEJhc2ljLkFsbCBVc2VyLlJlYWRXcml0ZSBVc2VyLlJlYWRXcml0ZS5BbGwgZW1haWwiLCJzaWduaW5fc3RhdGUiOlsia21zaSJdLCJzdWIiOiJYVVBueVBxVGZxRFREeGdJeERZT093U3BVQVNBc3ZQbk1wOFRsQ0gweDNnIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkVVIiwidGlkIjoiMjQ1ZGQzOTMtN2ViNy00MThhLWEyZWItOTBlMTdlZGU3Y2MyIiwidW5pcXVlX25hbWUiOiJsYWJhZG1pbkBhenVyZS5jaG5pZWIuZGUiLCJ1cG4iOiJsYWJhZG1pbkBhenVyZS5jaG5pZWIuZGUiLCJ1dGkiOiJ3UDBEVjhlYjgwV3Q1c29mdS1jaUFBIiwidmVyIjoiMS4wIiwid2lkcyI6WyI2MmU5MDM5NC02OWY1LTQyMzctOTE5MC0wMTIxNzcxNDVlMTAiLCIzYTJjNjJkYi01MzE4LTQyMGQtOGQ3NC0yM2FmZmVlNWQ5ZDUiLCJiNzlmYmY0ZC0zZWY5LTQ2ODktODE0My03NmIxOTRlODU1MDkiXSwieG1zX3N0Ijp7InN1YiI6IkZjNXRhN25pcldtekVYMER5Ym5ZQnktNldjZjM5U2s3SVVjcFRFQlJZdXMifSwieG1zX3RjZHQiOjE2MzE2OTk4MzF9.A8CfM44IF4ac1xs73s5Ttk5ut16kelSGjXewXc_fXLYbg8HLJ45po-dpLXRLmS2rBXMJ92lRmlbLfLYBg4mZl0aXYRUsW7RwG4C9eamsVNsdqTi-L-QJ4s5azUMZkpSIARd2e2c6rlvUtA1b0XBQyw0BJF6ceLQiFt1Fg89T8SbMB8li9J2AttTE2lVPUGlbXSAFe7NcpH6mCclslA1m4dDK4GGI2jm4PCmxnQt_jxXIFuN0xXqqKs1QKi-eXJCgecf5IAyhTqWww4RMKPlA_CkUaDVm9QPC5WzZT4TiNT2Pgv2bb0Xsl6dflcHSNr903zHQu13vN9o0_BskGakoXQ'
}

$result = Invoke-RestMethod -Headers $header -Uri "https://graph.microsoft.com/v1.0/me"



#endregion