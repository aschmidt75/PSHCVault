
Function Test-HCVaultTokenSelf {
    <#
    .SYNOPSIS
        Look up metadata of the token in current HCVaultContext

    .EXAMPLE
        > New-HCVaultContext -VaultAddr http://127.0.0.1:8200/ -VaultToken (ConvertTo-SecureString -AsPlainText "...")
        > Test-HCVaultTokenSelf

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#lookup-a-token-self
    #>
    [CmdletBinding()]
    param (
    )

    $ctx = GetContextOrErr

    $req = NewHCVaultAPIRequest -Method "GET" -Path "/auth/token/lookup-self"
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to lookup token: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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

    return $None

}
