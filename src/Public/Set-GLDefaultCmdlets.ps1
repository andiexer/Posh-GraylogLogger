
function Set-GLDefaultCmdlets {
    param(
        [switch]$Enabled,
        [switch]$Disabled
    )

    if ($Enabled) {
        . .\Private\Write-Debug.ps1
        . .\Private\Write-Error.ps1
        . .\Private\Write-Output.ps1
        . .\Private\Write-Verbose.ps1
        . .\Private\Write-Warning.ps1
    }
    elseif ($Disabled) {
        Remove-Item Function:\Write-Debug
        Remove-Item Function:\Write-Error
        Remove-Item Function:\Write-Output
        Remove-Item Function:\Write-Verbose
        Remove-Item Function:\Write-Warning
    }
}