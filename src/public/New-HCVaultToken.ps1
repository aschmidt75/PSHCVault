
function New-HCVaultToken {
    <#
    .SYNOPSIS
    Create a new token with options

    .EXAMPLE
    $c = New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
    $c | Update-HCVaultContext -Token (ConvertTo-SecureString -AsPlainText "<token>")
    $auth = New-HCVaultToken -ctx $c -Ttl 1h -Role default

    .LINK
    https://developer.hashicorp.com/vault/api-docs/auth/token#create-token
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [HCVaultContext]
        $ctx,

        [Parameter]
        [string]$Role,

        [Parameter]
        [string]$Ttl
    )

    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/token/create"
    $req.Body = @{
    }
    if ($Ttl) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "ttl" -Value $Ttl
    }
    if ($Ttl) {
        $req.Body | Add-Member -MemberType NoteProperty -Name "role_name" -Value $Role
    }
    if($SecretID) {
        $s = ConvertFrom-SecureString -AsPlainText $SecretID
        $req.Body | Add-Member -MemberType NoteProperty -Name "secret_id" -Value $s
    }
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $ctx -req $req 
    } catch {
        $msg = "Unable to create token: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
        throw [ErrorRecord]::new( 
            [InvalidOperationException]::new($msg), 
            'L1-{0}' -f $_.FullyQualifiedErrorId, 
            [ErrorCategory]::InvalidOperation, 
            $_
        )     
    }

    if ($res.StatusCode -eq 200) {
        # string reuqest-part, take only auth part
        # secure client_token within. 
        # Create Auth class from this
        $auth = New-HCVaultAuth -bodyAuthPart $res.Body.auth

        if ($UpdateContext) {
            $ctx.VaultToken = $auth.Token
        }

        return $auth
    }

    return $None
}