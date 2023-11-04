Function Show-HCVaultTokenAccessors {
    <#
    .SYNOPSIS
        Lists all available token accessors
    
    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#list-accessors

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $req = NewHCVaultAPIRequest -Method "GET" -Path "/auth/token/accessors?list=true"
        $res = $None    
        $ctx = GetContextOrErr
    }
    process {
        try {
            $res = InvokeHCVaultAPI -ctx $Ctx -req $req
        } catch {
            $msg = "Unable to list token accessors: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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