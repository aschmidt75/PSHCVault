Function Update-HCVaultTokenLease {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [HCVaultContext]
        $ctx,

        [Parameter()]
        [securestring]$Token
    )

    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/renew"
    $req.Body = @{
        "token" = ConvertFrom-SecureString -AsPlainText $Token
    }
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $ctx -req $req 
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
        return New-HCVaultAuth -bodyAuthPart $res.Body.auth
    }

    return $None

}

Function Update-HCVaultTokenLeaseSelf {
    <#
    .SYNOPSIS
    Look up metadata of the token in current HCVaultContext
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [HCVaultContext]
        $ctx
    )

    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/renew-self"
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $ctx -req $req 
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
        return New-HCVaultAuth -bodyAuthPart $res.Body.auth
    }

    return $None

}