Function Get-HCVaultSecretConfig {
    <#
    .SYNOPSIS
        Returns the configuration for a secret KV engine
    
    .EXAMPLE
        > New-HCVaultContext -VaultAddr http://127.0.0.1:8200/ -VaultToken (ConvertTo-SecureString -AsPlainText "...") 
        > Get-HCVaultSecretConfig -SecretMountPath /secret    

    .LINK
        https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#read-kv-engine-configuration
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [string]$SecretMountPath
    )

    $ctx = GetContextOrErr

    $p = "/{0}/config" -f $SecretMountPath
    $req = NewHCVaultAPIRequest -Method "GET" -Path $p
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to get config: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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