ipmo C:\dev\ps\Posh-GraylogLogger\PSGraylogLogger.psm1
$DebugPreference = 'Continue'

# Set Graylog Connection
New-GLServerConnection -Server 192.168.112.100 -Port 12201

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
    
    Start-Sleep -Milliseconds 250
}

Write-GLLog -LogLevel Debug -LogText "This is a test with additional log properties and one inline property: {TestProperty}" -PropertyValues @("TestPropertyValue") -AdditionalProperties @{AdditionalTestProperty = "Hallo Welt"}

# Write a fancy log message without named properties but with additional properties
Write-GLLog -LogLevel Debug -LogText "This is a test with additional log properties" -AdditionalProperties @{AdditionalTestProperty = "Hallo Welt"}