Function Test-HCVaultToken {
    <#
    .SYNOPSIS
        Look up metadata of a given token

    .DESCRIPTION 
        Uses the lookup-token endpoints to test a token. If no parameter is given,
        the token is taken from the current context. Otherwise a specific token
        can be tested by the token string itself or its accessor.

    .PARAMETER ctx  
        HCVaultContext object

    .PARAMETER Token
        Token to test

    .PARAMETER Accessor
        Token accessor to test 

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#lookup-a-token
        https://developer.hashicorp.com/vault/api-docs/auth/token#lookup-a-token-self
        https://developer.hashicorp.com/vault/api-docs/auth/token#lookup-a-token-accessor
    #>

    [CmdletBinding(DefaultParameterSetName="token")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "token")]
        [ValidateNotNullOrEmpty()]
        [securestring]$Token,                   # https://developer.hashicorp.com/vault/api-docs/auth/token#token

        [Parameter(Mandatory = $true, ParameterSetName = "accessor")]
        [ValidateNotNullOrEmpty()]
        [string]$Accessor                       # https://developer.hashicorp.com/vault/api-docs/auth/token#accessor
    )

    $ctx = GetContextOrErr

    # default: test self 
    $req = NewHCVaultAPIRequest -Method "GET" -Path "/auth/token/lookup-self"

    if ($PSBoundParameters.ContainsKey('token')) {
        $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/lookup"
        $req.Body = @{
            "token" = ConvertFrom-SecureString -AsPlainText $Token
        }
    }
    if ($PSBoundParameters.ContainsKey('accessor')) {
        $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/lookup-accessor"
        $req.Body = @{
            "accessor" = $Accessor
        }
    }
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
        # TODO: if ìd` is given, make it a SecureString

        return $res.Body.data
    }

    return $None

}
