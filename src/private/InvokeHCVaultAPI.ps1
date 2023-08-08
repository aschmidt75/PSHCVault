using namespace System.Management.Automation

function InvokeHCVaultAPI {
    <#
    .SYNOPSIS
    Invokes an API call to the vault instance

    .DESCRIPTION
    Invokes the v1 API call to the vault instance specified by given HCVaultContenxt.
    It invokes the call as specified by the HCVaultAPIRequest object, returning a
    HCVaultAPIResponse object. JSON conversion is done by this method as well as
    basic error handling.   
    #>
    Param(
        [Parameter(Mandatory=$true)]
        [HCVaultContext]$ctx,

        [Parameter(Mandatory=$true)]
        [HCVaultAPIRequest]$req

    )

    $uri = "{0}v1{1}" -f $ctx.VaultAddr, $req.Path
    $headers = @{ 
        "Content-Type" = "application/json"
    }
    # supply x-vault-token if we have it
    if ($ctx.VaultToken) {
        $tk = ConvertFrom-SecureString -AsPlainText $ctx.VaultToken
        $headers."X-Vault-Token" = $tk
    }
    $reqArgs = @{
        Uri = $Uri
        Method = $Req.Method
        Headers = $Headers
    }
    if ($ctx.Certificate) {
        $certArgs = @{
            Certificate = $ctx.Certificate
            SkipCertificateCheck = $true
        }
    }
    $res = New-Object HCVaultAPIResponse

    Write-Verbose "Invoking: $($req.Method) $uri" 
    try {
        if ($req.Method -eq "GET") {
            $resp = Invoke-WebRequest @reqArgs @certArgs
        }
        if ($req.Method -eq "POST") {
            $resp = $req.Body | ConvertTo-Json -Compress | Invoke-WebRequest @reqArgs @certArgs
        }

        $res.StatusCode = $resp.StatusCode
        if ($resp.StatusCode -eq 200) {
            $res.Body = $resp.Content | ConvertFrom-Json
        }
    } catch {
        $msg = "Error invoking HCVault API: $($req.Method) $uri"
        Write-Error $_ -ErrorAction Continue
        $to = [PSCustomObject]@{
            StatusCode = $res.StatusCode
            Exception = $_.Exception
        }
        throw [ErrorRecord]::new( 
            [Exception]::new($msg), 
            'L0__Invoke-HCVaultAPI', 
            [ErrorCategory]::NotSpecified, 
            $to
        )     
    }

    return $res
}