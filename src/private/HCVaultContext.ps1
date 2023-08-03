
class HCVaultContext {
    <#
    .SYNOPSIS
    Stores data to use the vault API.
    #>

    # mandatory URI of vault instance
    [String]$VaultAddr

    # optional: token
    [securestring]$VaultToken
}