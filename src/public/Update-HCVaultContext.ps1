
function Update-HCVaultContext {
    <#
    .SYNOPSIS
    Updates an HCVaultContext object with variables such as token etc.

    .EXAMPLE
    $Ctx | Update-HCVaultContext -Token $auth.token

    #>
    [CmdletBinding()]
    Param (
        [parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true)
        ]
        [ValidateNotNull()]
        [HCVaultContext]$Ctx,
        
        [Parameter()]
        [securestring]$Token,

        [Parameter()]
        [System.Security.Cryptography.X509Certificates.X509Certificate]$Certificate,

        [Parameter()]
        [switch]$SkipCertificateCheck

    )

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
        Write-Output $Ctx
    }
}