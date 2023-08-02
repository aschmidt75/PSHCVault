Function NewHCVaultAPIRequest {

    param (
        [Parameter()]
        [string]$Method,

        [Parameter()]
        [string]$Path
    )

    return [HCVaultAPIRequest]@{
        Method = $Method
        Path = $Path
    }

}