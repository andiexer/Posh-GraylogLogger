function Add-GLGlobalLogProperties {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Properties
    )

    foreach($property in $Properties.GetEnumerator()) {
        Add-GLGlobalLogProperty -PropertyName $property.Key -PropertyValue $property.Value
    }
}