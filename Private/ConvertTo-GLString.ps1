function ConvertTo-GLString {
    param(
        [Parameter(Mandatory=$true)]
        [object]$value
    )

    switch($value.GetType().Name) 
    {
        "PSCustomObject" {
            return ConvertTo-Json $value -Compress -Depth 5
        }
        default {
            return $value.ToString()
        }
    }
}