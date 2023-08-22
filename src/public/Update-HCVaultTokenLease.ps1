Function Update-HCVaultTokenLease {
    <#
    .SYNOPSIS
        Renews a token  

    .DESCRIPTION
        Uses the /auth/token/renew endpoint to renew a given token. If token is
        not explicitely given, it is taken from the context.

    .EXAMPLE
        > Update-HCVaultTokenLease -Token $auth.Token
        > (Test-HCVaultToken -Token $auth.token).ttl

    .EXAMPLE
        > Update-HCVaultTokenLease
        > Test-HCVaultTokenSelfc

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#renew-a-token
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [securestring]$Token            # https://developer.hashicorp.com/vault/api-docs/auth/token#token-1
    )

    $Ctx = GetContextOrErr

    if ($Token -eq $null) {
        $Token = $Ctx.VaultToken
    }
    
    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/renew"
    $req.Body = @{
        "token" = ConvertFrom-SecureString -AsPlainText $Token
    }
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to renew token: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        return NewHCVaultAuth -bodyAuthPart $res.Body.auth
    }

    return $None

}

Function Update-HCVaultTokenLeaseSelf {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [HCVaultContext]
        $Ctx
    )

    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/renew-self"
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to renew token: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        return NewHCVaultAuth -bodyAuthPart $res.Body.auth
    }

    return $None

}