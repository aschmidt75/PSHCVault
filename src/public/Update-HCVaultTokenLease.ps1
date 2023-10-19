Function Update-HCVaultTokenLease {
    <#
    .SYNOPSIS
        Renews a token by its token string or its accessor

    .DESCRIPTION
        Uses the /auth/token/renew or renew-accessor endpoint to renew a given token. If token is
        not explicitely given, it is taken from the context.

    .EXAMPLE
        > Update-HCVaultTokenLease -Token $auth.Token
        > (Test-HCVaultToken -Token $auth.token).ttl

    .EXAMPLE
        > Update-HCVaultTokenLease -Accessor <some_accessor>
        > (Test-HCVaultToken -Token $auth.token).ttl

    .EXAMPLE
        > Update-HCVaultTokenLease
        > Test-HCVaultTokenSelf

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#renew-a-token
        https://developer.hashicorp.com/vault/api-docs/auth/token#renew-a-token-accessor 
    #>
    [CmdletBinding(DefaultParameterSetName="token")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "token")]
        [ValidateNotNullOrEmpty()]
        [securestring]$Token,               # https://developer.hashicorp.com/vault/api-docs/auth/token#token-1

        [Parameter(Mandatory = $true, ParameterSetName = "accessor")]
        [ValidateNotNullOrEmpty()]
        [string]$Accessor                   # https://developer.hashicorp.com/vault/api-docs/auth/token#accessor
    )

    $Ctx = GetContextOrErr

    if ($PSBoundParameters.ContainsKey('token')) {
        $req = NewHCVaultAPIRequest -Method "POST" -Path  "/auth/token/renew"
        $req.Body = @{
            "token" = ConvertFrom-SecureString -AsPlainText $Token
        }
    }
    if ($PSBoundParameters.ContainsKey('accessor')) {
        $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/renew-accessor"
        $req.Body = @{
            "accessor" = $Accessor
        }
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
        Renews the "self" token in the current context  

    .DESCRIPTION
        Uses the /auth/token/renew endpoint to renew the token from the current context.

    .EXAMPLE
        > Update-HCVaultTokenLeaseSelf
        > (Test-HCVaultTokenSelf).ttl

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#renew-a-token
    #>

    $Ctx = GetContextOrErr

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