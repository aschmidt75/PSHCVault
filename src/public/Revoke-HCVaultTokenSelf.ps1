Function Revoke-HCVaultTokenSelf {
    <#
    .SYNOPSIS
        Revokes the token in the current context

    .DESCRIPTION
        Uses the /auth/token/revoke-self endpoint to revoke the token from the current context.

    .EXAMPLE
        > Revoke-HCVaultTokenSelf
        > Test-HCVaultTokenSelf

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#revoke-a-token-self
    #>
    [CmdletBinding()]
    param (
    )

    $Ctx = GetContextOrErr
    
    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/revoke-self"
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to revoke token-self: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        return $res.Body
    }

    return $None

}
