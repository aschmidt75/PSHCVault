function Get-HCVaultSealStatus {
    <#
    .SYNOPSIS
        Queries the system seal status of a vault instance.

    .EXAMPLE
        New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
        Get-HCVaultSealStatus

    .LINK
        https://developer.hashicorp.com/vault/api-docs/system/seal-status

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $req = NewHCVaultAPIRequest -Method "GET" -Path "/sys/seal-status"
        $res = $None    
        $ctx = GetContextOrErr
    }
    process {
        try {
            $res = InvokeHCVaultAPI -ctx $Ctx -req $req
        } catch {
            $msg = "Unable to get seal status: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
            throw [ErrorRecord]::new( 
                [InvalidOperationException]::new($msg), 
                'L1-{0}' -f $_.FullyQualifiedErrorId, 
                [ErrorCategory]::InvalidOperation, 
                $_
            )     
        }
    }
    end {
        if ($res.StatusCode -eq 200) {
            return $res.Body
        }
        return $None    
    }
}