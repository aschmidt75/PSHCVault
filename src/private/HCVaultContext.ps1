
class HCVaultContext {
    <#
    .SYNOPSIS
    Stores data to use the vault API.
    #>

    # mandatory URI of vault instance
    [String]$VaultAddr

    # optional: token
    [securestring]$VaultToken

    # optional: X509 key/certificate to connect with if $VaultAddr is https
    [System.Security.Cryptography.X509Certificates.X509Certificate]$Certificate

    # optional: SkipCertificateCheck for self-signed certificates or certs not in trust store
    [boolean]$SkipCertificateCheck
}