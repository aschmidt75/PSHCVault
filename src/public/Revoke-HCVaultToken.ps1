Function Revoke-HCVaultToken {
    <#
    .SYNOPSIS
        Revokes a token by token string or its accessor

    .DESCRIPTION
        Uses the /auth/token/revoke or revoke-accessor endpoint to revoke a token.

    .EXAMPLE
        Revoke-HCVaultToken -Token <some_token>
        Test-HCVaultToken -Token <some_token>       # returns error "bad token"

    .EXAMPLE
        Revoke-HCVaultToken -Accessor <some_accessor>
        Test-HCVaultToken -Token <some_token>             # returns error "bad token"
        Test-HCVaultToken -Accessor <some_accessor>       # returns error "invalid accessor"

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#revoke-a-token
        https://developer.hashicorp.com/vault/api-docs/auth/token#revoke-a-token-accessor
    #>
    [CmdletBinding(DefaultParameterSetName="token")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "token")]
        [ValidateNotNullOrEmpty()]
        [securestring]$Token,

        [Parameter(Mandatory = $true, ParameterSetName = "accessor")]
        [ValidateNotNullOrEmpty()]
        [string]$Accessor
    )

    $Ctx = GetContextOrErr
    
    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/revoke-self"
    if ($PSBoundParameters.ContainsKey('token')) {
        $req = NewHCVaultAPIRequest -Method "POST" -Path  "/auth/token/revoke"
        $req.Body = @{
            "token" = ConvertFrom-SecureString -AsPlainText $Token
        }
    }
    if ($PSBoundParameters.ContainsKey('accessor')) {
        $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/revoke-accessor"
        $req.Body = @{
            "accessor" = $Accessor
        }
    }

    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to revoke token: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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
