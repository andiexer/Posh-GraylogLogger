function Add-GLGlobalLogProperty {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PropertyName,
        [Parameter(Mandatory=$true)]
        [object]$PropertyValue
    )
    $global:GLLoggingProperties[$PropertyName] = ConvertTo-GLString $PropertyValue
    Write-Debug "Added new entry to global log properties. key: $PropertyName value: $(ConvertTo-GLString $PropertyValue)"
}