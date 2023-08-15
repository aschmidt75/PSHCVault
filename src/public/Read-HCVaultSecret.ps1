Function Read-HCVaultSecret {
    <#
    .SYNOPSIS
        Reads a secret along with its metadata from a given path
    
    .EXAMPLE
        > Read-HCVaultSecret -ctx $c -SecretMountPath secret -Path my-secret
        data            metadata
        ----            --------
        @{bar=b; foo=a} @{created_time=2023-07-13T13:32:02.565202827Z; custom_metadata=; deletion_time=; destroyed=False; version=1}

    .EXAMPLE
        > Read-HCVaultSecret -SecretMountPath secret -Path my-secret -ExpandData foo
        System.Security.SecureString 
    
    .LINK
        https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#read-secret-version
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SecretMountPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        <# Expands the data element with the desired item, as a securestring. Do not return Metadata #>
        [Parameter()]
        [string]$ExpandData = $null
    )

    $ctx = GetContextOrErr

    $p = "/{0}/data/{1}" -f $SecretMountPath, $Path
    $req = NewHCVaultAPIRequest -Method "GET" -Path $p
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to read secret: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        if ($ExpandData -and $res.Body.data.data) {
            $item = $res.Body.data.data | Select-Object -ExpandProperty $ExpandData
            return ConvertTo-SecureString -AsPlainText $item
        }
        return $res.Body.data
    }

}