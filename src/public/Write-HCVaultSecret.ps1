Function Write-HCVaultSecret {
    <#
    .SYNOPSIS
    Writes a secret to the KV engine
    
    .EXAMPLE
    > Write-HCVaultSecret -ctx $c -SecretMountPath secret -Path my-secret -Data @{ "baz" = "wooz" } -Verbose

    .LINK
    https://developer.hashicorp.com/vault/api-docs/secret/kv/kv-v2#create-update-secret
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [HCVaultContext]
        $Ctx,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SecretMountPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter()]
        [PSObject]$Data = $null
    )

    $p = "/{0}/data/{1}" -f $SecretMountPath, $Path
    $req = NewHCVaultAPIRequest -Method "POST" -Path $p
    $req.Body = @{
    }
    if ($Data) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "data" -Value $Data
    }
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to write secret: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        return $res.Body.data
    }

}