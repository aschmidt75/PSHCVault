Function NewHCVaultAuth {
    <#
    .SYNOPSIS
    Create an instance of HCVaultAuth from a auth response, including wrapping the token in a [securestring]
    #>
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSCustomObject]$BodyAuthPart
    )

    $client_token_sec = $null
    if (
        ($null -ne $BodyAuthPart.client_token) -and
        ($BodyAuthPart.client_token.Length -gt 0)
    ) {
        $client_token_sec = ConvertTo-SecureString -AsPlainText $BodyAuthPart.client_token
    }
    return [HCVaultAuth] @{
        Token = $client_token_sec
        Accessor = $BodyAuthPart.accessor
        LeaseDuration = $BodyAuthPart.lease_duration
        Renewable = $BodyAuthPart.renewable
        TokenType = $BodyAuthPart.token_type
        Orphan = $BodyAuthPart.orphan
        MFARequirement = $BodyAuthPart.mfa_requirement
        NumUses = $BodyAuthPart.num_uses
    }
}