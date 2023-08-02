class HCVaultAuth {
    <#
    .SYNOPSIS
    HCVaultAuth models the "auth" json part of an auth/* response

    .DESCRIPTION
    e.g.,
    client_token    : System.Security.SecureString
    accessor        : Ipsz0PWeR6OcDN9XNUvsxoxZ
    policies        : {default}
    token_policies  : {default}
    metadata        : @{role_name=r1}
    lease_duration  : 6000
    renewable       : True
    entity_id       : eb36e4d5-954f-b83d-ef98-b21b63d11033
    token_type      : service
    orphan          : True
    mfa_requirement : 
    num_uses        : 1000
   
    #>

    [securestring]$Token       
    [string]$Accessor
    [Int64]$LeaseDuration
    [bool]$Renewable
    [string]$TokenType
    [bool]$Orphan
    [string]$MFARequirement
    [Int64]$NumUses
}