
BeforeAll {    
    $token = ("root" | ConvertTo-SecureString -AsPlainText)
    New-HCVaultContext -VaultAddr "http://127.0.0.1:8200/" -VaultToken $token 
}

Describe 'Get-HCVaultHealth' {
    It 'should return instance health' {
        $h = Get-HCVaultHealth
        $h | Should -Not -BeNullOrEmpty

        $h.initialized | Should -Be "True"
        $h.sealed | Should -Be "False"
        $h.cluster_name | Should -No -BeNullOrEmpty
        $h.cluster_id | Should -No -BeNullOrEmpty
    }
}

Describe 'Get-HCVaultSealStatus' {
    It 'should return instance seal status' {
        $h = Get-HCVaultSealStatus
        $h | Should -Not -BeNullOrEmpty

        $h.initialized | Should -Be "True"
        $h.sealed | Should -Be "False"
        $h.cluster_name | Should -No -BeNullOrEmpty
        $h.cluster_id | Should -No -BeNullOrEmpty
    }
}
