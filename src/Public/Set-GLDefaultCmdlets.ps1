
function Set-GLDefaultCmdlets {
    param(
        [switch]$Enable,
        [switch]$Disable
    )

    if ($Enable) {
        Microsoft.PowerShell.Utility\Write-Debug "Overwrite basic write PowerShell cmdlets"
        . "$($global:GLModuleBasePath)\Private\BaseFunctions\Write-Debug.ps1"
        . "$($global:GLModuleBasePath)\Private\BaseFunctions\Write-Error.ps1"
        . "$($global:GLModuleBasePath)\Private\BaseFunctions\Write-Output.ps1"
        . "$($global:GLModuleBasePath)\Private\BaseFunctions\Write-Verbose.ps1"
        . "$($global:GLModuleBasePath)\Private\BaseFunctions\Write-Warning.ps1"
    }
    elseif ($Disable) {
        Microsoft.PowerShell.Utility\Write-Debug "Remove basic write PowerShell cmdlets"
        Remove-Item Function:\Write-Debug
        Remove-Item Function:\Write-Error
        Remove-Item Function:\Write-Output
        Remove-Item Function:\Write-Verbose
        Remove-Item Function:\Write-Warning
    }
}