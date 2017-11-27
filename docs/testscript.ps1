ipmo C:\dev\ps\Posh-GraylogLogger\src\PSGraylogLogger.psm1
$DebugPreference = 'Continue'

# Set Graylog Connection
New-GLServerConnection -Server 192.168.112.100 -Port 5556 -TransportMode udp

# Add Additional Global Log Properties for Script
Add-GLGlobalLogProperty -PropertyName "ScriptName" -PropertyValue "ApiMonitoringScript.ps1"
Add-GLGlobalLogProperty -PropertyName "Source" -PropertyValue "PowershellScript"
Add-GLGlobalLogProperty -PropertyName "Environment" -PropertyValue "Development"

# write a fancy log message
1..10000 | % {
    if((Get-Random -Minimum 1 -Maximum 100) -gt 50) {
        Write-GLLog -LogLevel Informational -LogText "This is a demo. Processingtime: {ProcessingTime}. API Status is: {IncidentApiStatus}" -PropertyValues @((Get-Random), "healthy" )
    } else {
        Write-GLLog -LogLevel Critical -LogText "This is a demo. Processingtime: {ProcessingTime}. API Status is: {IncidentApiStatus}" -PropertyValues @((Get-Random), "unhealthy" )
    }
    
    #Start-Sleep -Milliseconds 250
}

Write-GLLog -LogLevel Debug -LogText "This is a test with additional log properties and one inline property: {TestProperty}" -PropertyValues @("TestPropertyValue") -AdditionalProperties @{AdditionalTestProperty = "Hallo Welt"; Services = (ConvertTo-Json (Get-Service)).ToString()}

# Write a fancy log message without named properties but with additional properties
Write-GLLog -LogLevel Debug -LogText "This is a test with additional log properties" -AdditionalProperties @{AdditionalTestProperty = "Hallo Welt"}





[System.Text.Encoding]::ASCII.GetBytes([Math]::Floor( [decimal] (Get-Date ([dateTime]::Now.ToUniversalTime()) -UFormat '%s')).ToString())


 [Object]$Random = New-Object System.Random
    $GelfMessageID = New-Object Byte[] 8
$Random.NextBytes($GelfMessageID)
 
 remove-m