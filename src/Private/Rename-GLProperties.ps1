function Rename-GLProperties {
    param(
        [hashtable]$LogProperties
    )
    $DefaultFields = @("version","host","short_message","full_message","timestamp","level","facility","line","file")
    $fixedLogProperties = @{}

    foreach($logProperty in $LogProperties.GetEnumerator())
    {
        $prefix = ""
        if(!$DefaultFields.contains($logProperty.Key.ToLower())) {
            $prefix = "_"
        }
        $fixedLogProperties.Add($prefix+$logProperty.Key, $logProperty.Value)
    }
    return $fixedLogProperties
}