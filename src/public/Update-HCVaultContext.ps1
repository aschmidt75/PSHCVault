
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
        [securestring]$Token
    )

    Process {
        if ($Token) {
            $Ctx.VaultToken = $Token
        }
    }
    End {
        Write-Output $Ctx
    }
}