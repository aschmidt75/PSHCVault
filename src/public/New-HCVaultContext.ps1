
function New-HCVaultContext {
    <#
    .SYNOPSIS
    Creates a new HCVaultContext object from parameters.
    
    #>
    [CmdletBinding()]
    Param (
        [Parameter()]
        [String]$VaultAddr = "https://127.0.0.1:8200"
    )

    $ctx = New-Object HCVaultContext
    $ctx.VaultAddr = $VaultAddr

    $ctx
}