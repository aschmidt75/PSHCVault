
function Update-HCVaultContext {
    <#
    .SYNOPSIS
    Updates an HCVaultContext object with variables such as token etc.

    .EXAMPLE
    $ctx | Update-HCVaultContext -Token $auth.token

    #>
    [CmdletBinding()]
    Param (
        [parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true)
        ]
        [HCVaultContext]$context,
        
        [Parameter()]
        [securestring]$Token
    )

    Process {
        if ($Token) {
            $context.VaultToken = $Token
        }
    }
    End {
        Write-Output $context
    }
}