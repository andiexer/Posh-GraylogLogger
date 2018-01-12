#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#initialize global Parameters
$global:GLLoggingProperties = @{}
$global:GLModuleBasePath = $PSScriptRoot
$global:GLDefaultConfigFileName = "psgrayloglogger.settings"
$global:GLLoggingProperties.Add("host", $env:COMPUTERNAME)
$global:GLServer = $null
$global:GLPort = $null
$global:GLHttpEndpoint = $null
$global:GLTransportMode = $null

#initialize enum values
Add-Type -TypeDefinition @"
public enum GLLogLevel
{
   Emergency,
   Alert,
   Critical,
   Error,
   Warning,
   Notice,
   Informational,
   Debug
}
"@

Add-Type -TypeDefinition @"
public enum GLTransportMode
{
    Http,
    Https,
    Tcp,
    Udp
}
"@


#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Microsoft.PowerShell.Utility\Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
