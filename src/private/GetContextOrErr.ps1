function GetContextOrErr() {
    <#
    .SYNOPSIS
        Returns the current context from the Script scope or stops with an error message.
    #>
    $ctx = $SCRIPT:HCVaultContext
    if (-not $ctx) {
        Write-Error -Message "No context set. Use New-HCVaultContext first." -Category ObjectNotFound -ErrorAction Stop
    }
    return $ctx
}