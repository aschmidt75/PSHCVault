# Used to determine if we are connected to anything
$Script:Headers = $null

# Used to always have a recent set of parameters used to invoke a REST method
$Script:RESTParams = @{
    'Uri' = $null
    'Headers' = $null
    'Body' = @{}
    'Method' = 'Get'
}
