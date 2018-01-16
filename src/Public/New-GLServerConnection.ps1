
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
        [string]$ConfigFilePath,
        [Parameter(Mandatory=$false, ParameterSetName='ConfigFile')]
        [Parameter(ParameterSetName='Server')]
        [switch]$EnableDefaultCmdlets,
        [Parameter(Mandatory=$false, ParameterSetName='Server')]
        [Parameter(Mandatory=$false, ParameterSetName='ConfigFile')]
        [string]$SourceType = "Powershell",
        [Parameter(Mandatory=$false, ParameterSetName='Server')]
        [Parameter(Mandatory=$false, ParameterSetName='ConfigFile')]
        [string]$TransactionId,
        [Parameter(Mandatory=$false, ParameterSetName='Server')]
        [Parameter(Mandatory=$false, ParameterSetName='ConfigFile')]
        [string]$ScriptName
    )

   ($ConfigFilePath -eq "")
    if($ConfigFile) {
        if([string]::IsNullOrEmpty($ConfigFilePath)) {
            Microsoft.PowerShell.Utility\Write-Debug "using default path and filename"
            $ConfigFilePath = "$($global:GLModuleBasePath)\$($global:GLDefaultConfigFileName)"
        } else {
            Microsoft.PowerShell.Utility\Write-Debug "using custom configfilepath: $ConfigFilePath"
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

    if([string]::IsNullOrEmpty($ScriptName)) {
        if([string]::IsNullOrEmpty($MyInvocation.MyCommand.Name)) {
            $global:GLLoggingProperties["ScriptName"] = "RUNSPACE"
        } else {
            $global:GLLoggingProperties["ScriptName"] = $MyInvocation.ScriptName.Split("\")[-1]
        }
    }

    if([string]::IsNullOrEmpty($TransactionId)) {
        $global:GLLoggingProperties["TransactionId"] = (New-Guid).Guid
    } else {
        $global:GLLoggingProperties["TransactionId"] = $TransactionId
    }

    $global:GLLoggingProperties["SourceType"] = $SourceType
    $global:GLTransportMode = $TransportMode

    if($TransportMode -eq [GLTransportMode]::Http -or $TransportMode -eq [GLTransportMode]::Https) {
        Microsoft.PowerShell.Utility\Write-Debug "using http/https endpoint"
        $global:GLHttpEndpoint = "{0}://{1}:{2}/{3}" -f $TransportMode, $Server, $Port, $Endpoint
    } else {
        Microsoft.PowerShell.Utility\Write-Debug "using tcp/udp endpoint"
        $global:GLLoggingProperties.Add("version","1.1")
        $global:GLServer = $Server
        $global:GLPort = $Port
        $global:GLHttpEndpoint = $null
    }

    if ($EnableDefaultCmdlets) {
        Set-GLDefaultCmdlets -Enable
    }

}