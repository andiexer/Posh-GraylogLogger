function Write-GLLog {
    param(
        [Parameter(Mandatory=$true)]
        [GLLogLevel]$LogLevel,
        [Parameter(Mandatory=$true)]
        [string]$LogText,
        [Parameter(Mandatory=$false)]
        [array]$PropertyValues = @(),
        [Parameter(Mandatory=$false)]
        [hashtable]$AdditionalProperties = @{}
    )

    $regexResult = [regex]::Matches($logText,"(?<start>\{)+(?<property>[\w\.\[\]]+)(?<format>:[^}]+)?(?<end>\})+")
    $currentLogProperties = $global:GLLoggingProperties.Clone()
    $currentLogProperties['LogTemplate'] = $LogText
    $currentLogProperties['level'] = $LogLevel
    $currentLogProperties['timestamp'] = [Math]::Floor( [decimal] (Get-Date ([dateTime]::Now.ToUniversalTime()) -UFormat '%s'));
    Write-Debug "found $($regexResult.Count) placeholders for structured logging"
    if($regexResult.Count -ne $PropertyValues.Count) {
        throw "unable create log entry. structured log placeholders amount does not match PropertyValues amount"
    }
  
    for($i = 0; $i -lt $regexResult.Count; $i++) {
        $stringifiedValue = ConvertTo-GLString $PropertyValues[$i]
        $LogText = $LogText.Replace($regexResult[$i].Value, $stringifiedValue)
        $currentLogProperties[$regexResult[$i].Groups['property'].Value] = $stringifiedValue
    }
    $currentLogProperties["short_message"] = $LogText

    if($AdditionalProperties.Count -gt 0) {
        foreach($additionalProperty in $AdditionalProperties.GetEnumerator()) {
            $currentLogProperties[$additionalProperty.Key] = $additionalProperty.Value
        }
    }

    Write-Debug "sending log entry to graylog url: $($global:GLHttpEndpoint)"
    Invoke-RestMethod -Method POST -Uri $global:GLHttpEndpoint -Body (ConvertTo-Json $currentLogProperties) -ContentType 'application/json'
}




