function New-GLServerConnection {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Server,
        [Parameter(Mandatory=$true)]
        [int]$Port,
        [string]$Endpoint = "gelf"
    )

    $global:GLServer = "http://{0}:{1}/{2}" -f $Server, $Port, $Endpoint
    Write-Debug "Setting Graylog Server URL to: $($global:GLServer)"
}