function Get-HCVaultHealth {
    <#
    .SYNOPSIS
    Queries the system helath of a vault instance.
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [HCVaultContext]
        $ctx
    )

    begin {
        $req = NewHCVaultAPIRequest -Method "GET" -Path "/sys/health"
        $res = $None    
    }
    process {
        try {
            $res = InvokeHCVaultAPI -ctx $ctx -req $req
        } catch {
            $msg = "Unable to get health: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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