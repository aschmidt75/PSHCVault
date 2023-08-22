Function Set-HCVaultSecretConfig {
    <#
    .SYNOPSIS
        Set aspects of the configuration for a secret KV engine
    
    .EXAMPLE
        > Set-HCVaultSecretConfig -SecretMountPath /secret -DeleteVersionAfter "8h"
        > Get-HCVaultSecretConfig

    .LINK
        https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#configure-the-kv-engine
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SecretMountPath,               # https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#secret-mount-path

        [Parameter(Mandatory=$false)]
        [Boolean]$CasRequired,                  # https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#cas_required

        [Parameter(Mandatory=$false)]
        [String]$DeleteVersionAfter = $Null,    # https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#delete_version_after

        [Parameter(Mandatory=$false)]
        [Int64]$MaxVersions                     # https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#max_versions

    )

    $ctx = GetContextOrErr

    $p = "/{0}/config" -f $SecretMountPath
    $req = NewHCVaultAPIRequest -Method "POST" -Path $p
    $req.Body = @{
    }
    if ($CasRequired -ne $Null) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "cas_required" -Value $CasRequired
    }
    if ($DeleteVersionAfter) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "delete_version_after" -Value $DeleteVersionAfter
    }
    if ($MaxVersions) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "max_versions" -Value $MaxVersions
    }
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to set config: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        return $res.Body.data
    }

}