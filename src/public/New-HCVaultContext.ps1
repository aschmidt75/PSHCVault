
function New-HCVaultContext {
    <#
    .SYNOPSIS
        Creates a new HCVaultContext object from parameters.
    
    .PARAMETER VaultAddr
        Uri of Vault Address. Defaults to localhost, encrypted.

    .PARAMETER Token
        Optional token to authemticate with.

    .EXAMPLE
        $c = New-HCVaultContext -VaultAddr http://127.0.0.1:8200 -VaultToken $tk
    #>
    [CmdletBinding()]
    Param (
        [Parameter()]
        [String]$VaultAddr = "https://127.0.0.1:8200",

        [Parameter()]
        [securestring]$VaultToken 
    )

    $ctx = New-Object HCVaultContext

    $vaultAddrUri = [System.Uri]$VaultAddr
    $ctx.VaultAddr = $vaultAddrUri.AbsoluteUri

    $ctx.VaultToken = $VaultToken

    $ctx
}