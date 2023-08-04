Function Set-HCVaultSecretConfig {
    <#
    .SYNOPSIS
    Set aspect of the configuration for a secret KV engine
    
    .EXAMPLE

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

        [Parameter(Mandatory=$false)]
        [Boolean]$CasRequired,           # TODO make optional

        [Parameter(Mandatory=$false)]
        [String]$DeleteVersionAfter = $Null,

        [Parameter(Mandatory=$false)]
        [Int64]$MaxVersions           # TODO make optional

    )

    $p = "/{0}/config" -f $SecretMountPath
    $req = NewHCVaultAPIRequest -Method "POST" -Path $p
    $req.Body = @{
    }
    if ($CasRequired -ne $Null) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "cas_required" -Value $CasRequired
    }
    if ($DeleteVersionAfter) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "delete_version_after" -Value $DeleteVersionAfter
    }
    if ($MaxVersions) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "max_versions" -Value $MaxVersions
    }
    $res = $None

    Write-Verbose ($req.Body | ConvertTo-Json)

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to set config: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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