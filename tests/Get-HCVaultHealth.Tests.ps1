
BeforeAll {    
    $token = ("root" | ConvertTo-SecureString -AsPlainText)
    $cert  = Get-PfxCertificate -FilePath client.pfx
    $local = New-HCVaultContext -VaultAddr "https://127.0.0.1:9200/" -VaultToken $token -Certificate $cert -SkipCertificateCheck
}

Describe 'Get-HCVaultHealth' {
    It 'should return instance health' {
        $h = Get-HCVaultHealth -Ctx $local
        $h | Should -Not -BeNullOrEmpty

        $h.initialized | Should -Be "True"
        $h.sealed | Should -Be "False"
        $h.cluster_name | Should -No -BeNullOrEmpty
        $h.cluster_id | Should -No -BeNullOrEmpty
    }
}
