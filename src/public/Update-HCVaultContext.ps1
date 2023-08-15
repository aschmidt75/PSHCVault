
function Update-HCVaultContext {
    <#
    .SYNOPSIS
    Updates an HCVaultContext object with variables such as token etc.

    .EXAMPLE
    Update-HCVaultContext -Token $auth.token

    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [securestring]$Token,

        [Parameter(Mandatory=$false)]
        [System.Security.Cryptography.X509Certificates.X509Certificate]$Certificate,

        [Parameter(Mandatory=$false)]
        [switch]$SkipCertificateCheck

    )

    Begin {
        $Ctx = GetContextOrErr
    }
    Process {
        if ($Token) {
            $Ctx.VaultToken = $Token
        }
        if ($Certificate) {
            $Ctx.Certificate = $Certificate
        }
        $Ctx.SkipCertificateCheck = $SkipCertificateCheck
    }
    End {
        $SCRIPT:HCVaultContext = $Ctx
    }
}