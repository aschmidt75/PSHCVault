Function Get-HCVaultTokenRole {
    <#
    .SYNOPSIS
        Reads a token role given by its role name
    
    .PARAMETER RoleName
        The role name to query

    .LINK
        https://developer.hashicorp.com/vault/api-docs/auth/token#read-token-role

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$RoleName               # https://developer.hashicorp.com/vault/api-docs/auth/token#role_name-1
    )

    begin {
        $req = NewHCVaultAPIRequest -Method "GET" -Path ("/auth/token/roles/{0}" -f $RoleName)
        $res = $None    
        $ctx = GetContextOrErr
    }
    process {
        try {
            $res = InvokeHCVaultAPI -ctx $Ctx -req $req
        } catch {
            $msg = "Unable to get token roles: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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