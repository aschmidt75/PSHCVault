Function Test-HCVaultToken {
    <#
    .SYNOPSIS
        Look up metadata of a given token

    .PARAMETER ctx  
        HCVaultContext object

    .PARAMETER Token
        Token to test 
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [HCVaultContext]
        $Ctx,

        [Parameter(
            Mandatory = $true
        )]
        [securestring]$Token
    )

    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/lookup"
    $req.Body = @{
        "token" = ConvertFrom-SecureString -AsPlainText $Token
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
        return $res.Body.data
    }

    return $None

}

Function Test-HCVaultTokenSelf {
    <#
    .SYNOPSIS
    Look up metadata of the token in current HCVaultContext
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [HCVaultContext]
        $Ctx
    )

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
