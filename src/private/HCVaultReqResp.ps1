
class HCVaultAPIRequest {
    <# HTTP Method #>
    [string]$Method

    <# API Path after version, namespace. e.g., "auth/approle/login" #>
    [string]$Path

    <# optional API request object. Will be converted to JSON #>
    [PSObject]$Body
}

class HCVaultAPIResponse {
    [Int16]$StatusCode

    [PSObject]$Body
}
