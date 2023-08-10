
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
    [OutputType([psobject])]
    Param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$VaultAddr = "https://127.0.0.1:8200",

        [Parameter()]
        [securestring]$VaultToken,

        [Parameter()]
        [System.Security.Cryptography.X509Certificates.X509Certificate]$Certificate,

        [Parameter()]
        [switch]$SkipCertificateCheck
    )

    $Ctx = New-Object HCVaultContext

    $vaultAddrUri = [System.Uri]$VaultAddr
    $Ctx.VaultAddr = $vaultAddrUri.AbsoluteUri

    $Ctx.VaultToken = $VaultToken

    $Ctx.Certificate = $Certificate
    if ($Ctx.Certificate -and ($vaultAddrUri.Scheme -ne "https")) {
        Write-Warning "Supplied -Certificate for non-https -VaultAddr"
    } 

    $Ctx.SkipCertificateCheck = $SkipCertificateCheck

    $Ctx
}