
function Set-GLDefaultCmdlets {
    param(
        [switch]$Enable,
        [switch]$Disable
    )

    if ($Enabled) {
        Microsoft.PowerShell.Utility\Write-Debug "Overwrite basic write PowerShell cmdlets"
        . .\Private\BaseFunctions\Write-Debug.ps1
        . .\Private\BaseFunctions\Write-Error.ps1
        . .\Private\BaseFunctions\Write-Output.ps1
        . .\Private\BaseFunctions\Write-Verbose.ps1
        . .\Private\BaseFunctions\Write-Warning.ps1
    }
    elseif ($Disabled) {
        Microsoft.PowerShell.Utility\Write-Debug "Remove basic write PowerShell cmdlets"
        Remove-Item Function:\Write-Debug
        Remove-Item Function:\Write-Error
        Remove-Item Function:\Write-Output
        Remove-Item Function:\Write-Verbose
        Remove-Item Function:\Write-Warning
    }
}