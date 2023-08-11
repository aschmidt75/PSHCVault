
BeforeAll {    
    $token = ("root" | ConvertTo-SecureString -AsPlainText)
    $cert  = Get-PfxCertificate -FilePath client.pfx
    $Local = New-HCVaultContext -VaultAddr "http://127.0.0.1:8200/" -VaultToken $token 
    $LocalTls = New-HCVaultContext -VaultAddr "https://127.0.0.1:9200/" -VaultToken $token -Certificate $cert -SkipCertificateCheck
}

Describe 'Get-HCVaultSealStatus' {
    It 'should return instance seal status' {
        $h = Get-HCVaultSealStatus -Ctx $Local
        $h | Should -Not -BeNullOrEmpty

        $h.initialized | Should -Be "True"
        $h.sealed | Should -Be "False"
        $h.cluster_name | Should -No -BeNullOrEmpty
        $h.cluster_id | Should -No -BeNullOrEmpty
    }

    It 'should return instance seal status on TLS listener' {
        $h = Get-HCVaultSealStatus -Ctx $LocalTls
        $h | Should -Not -BeNullOrEmpty

        $h.initialized | Should -Be "True"
        $h.sealed | Should -Be "False"
        $h.cluster_name | Should -No -BeNullOrEmpty
        $h.cluster_id | Should -No -BeNullOrEmpty
    }
}
