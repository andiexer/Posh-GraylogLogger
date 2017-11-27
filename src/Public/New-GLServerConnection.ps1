
function New-GLServerConnection {
    [CmdletBinding(DefaultParameterSetName='Server')]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='Server')]
        [string]$Server,
        [Parameter(Mandatory=$true, ParameterSetName='Server')]
        [int]$Port,
        [Parameter(Mandatory=$true, ParameterSetName='Server')]
        [GLTransportMode]$TransportMode = [GLTransportMode]::Http,
        [Parameter(Mandatory=$false, ParameterSetName='Server')]
        [string]$Endpoint = "gelf",
        [Parameter(Mandatory=$true, ParameterSetName='ConfigFile')]
        [switch]$ConfigFile,
        [Parameter(Mandatory=$false, ParameterSetName='ConfigFile')]
        [string]$ConfigFilePath
    )

   ($ConfigFilePath -eq "")
    if($ConfigFile) {
        if([string]::IsNullOrEmpty($ConfigFilePath)) {
            Write-Debug "using default path and filename"
            $ConfigFilePath = "$($global:GLModuleBasePath)\$($global:GLDefaultConfigFileName)"
        } else {
            Write-Debug "using custom configfilepath: $ConfigFilePath"
        }
        if(![System.IO.File]::Exists($ConfigFilePath)){
            throw "unable to get configfile"
        }
        $configData = ConvertFrom-Json -InputObject (Get-Content -Path $ConfigFilePath -Raw)
        $Server = $configData.Server
        $Port = $configData.Port
        $Endpoint = if($configData.Endpoint -ne $null) {$configData.Endpoint}
        $TransportMode = [GLTransportMode]$configData.TransportMode
    }

    $global:GLTransportMode = $TransportMode
    if($TransportMode -eq [GLTransportMode]::Http -or $TransportMode -eq [GLTransportMode]::Https) {
        Write-Debug "using http/https endpoint"
        $global:GLHttpEndpoint = "{0}://{1}:{2}/{3}" -f $TransportMode, $Server, $Port, $Endpoint
    } else {
        Write-Debug "using tcp/udp endpoint"
        $global:GLServer = $Server
        $global:GLPort = $Port
        $global:GLHttpEndpoint = $null
    }
}