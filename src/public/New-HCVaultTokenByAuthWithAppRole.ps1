
function New-HCVaultTokenByAuthWithAppRole {
    <#
    .SYNOPSIS
    Requests a token by authenticating with AppRoleID and SecretID

    .DESCRIPTION
    Calls the /auth/approle/login endpoint to retrieve a token

    .PARAMETER ctx
    Object of class HCVaultContext

    .PARAMETER AppRoleID
    AppRoleID, mandatory

    .PARAMETER SecretID
    SecretID of AppRole, optional

    .PARAMETER UpdateContext
    If set to true, sets the received token into the passed context. Defaults to false

    .EXAMPLE
    $c = New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
    $r = "<app-role-id>"
    $s = ConvertTo-SecureString -AsPlainText "<secret-id>"
    $auth = New-HCVaultTokenByAuthWithAppRole.ps1 -ctx $c -AppRoleID $r -SecretID $s -UpdateContext
    Test-HCVaultTokenSelf -ctx $c                             

    .LINK
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [HCVaultContext]
        $Ctx,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppRoleID,

        [Parameter()]
        [securestring]$SecretID,

        [Parameter()]
        [switch]$UpdateContext = $false
    )

    $req = NewHCVaultAPIRequest -Method "POST" -Path "/auth/approle/login"
    $req.Body = @{
        role_id = $AppRoleID
    }
    if($SecretID) {
        $s = ConvertFrom-SecureString -AsPlainText $SecretID
        $req.Body | Add-Member -MemberType NoteProperty -Name "secret_id" -Value $s
    }
    $res = $None

    try {
        $res = InvokeHCVaultAPI -ctx $Ctx -req $req 
    } catch {
        $msg = "Unable to get token by app role: statusCode={0},Message={1}" -f $_.TargetObject.statusCode, $_.TargetObject.Exception.Message
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
            $Ctx.VaultToken = $auth.Token
        }

        return $auth
    }

    return $None
}