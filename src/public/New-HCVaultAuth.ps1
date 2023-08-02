Function New-HCVaultAuth {
    <#
    .SYNOPSIS
    Create an instance of HCVaultAuth from a auth response, including wrapping the token in a [securestring]
    #>
    param (
        [Parameter()]
        [PSCustomObject]$bodyAuthPart
    )

    $client_token_sec = ConvertTo-SecureString -AsPlainText $bodyAuthPart.client_token
    return [HCVaultAuth] @{
        Token = $client_token_sec
        Accessor = $bodyAuthPart.accessor
        LeaseDuration = $bodyAuthPart.lease_duration
        Renewable = $bodyAuthPart.renewable
        TokenType = $bodyAuthPart.token_type
        Orphan = $bodyAuthPart.orphan
        MFARequirement = $bodyAuthPart.mfa_requirement
        NumUses = $bodyAuthPart.num_uses
    }
}