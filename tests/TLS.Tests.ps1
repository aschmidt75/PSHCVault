
BeforeAll {    
    $token = ("root" | ConvertTo-SecureString -AsPlainText)
    $cert  = Get-PfxCertificate -FilePath client.pfx
    New-HCVaultContext -VaultAddr "https://127.0.0.1:9200/" -VaultToken $token -Certificate $cert -SkipCertificateCheck
}

Describe 'Get-HCVaultHealth TLS' {
    It 'should return instance health on TLS listener' {
        $h = Get-HCVaultHealth -Ctx $LocalTls
        $h | Should -Not -BeNullOrEmpty

        $h.initialized | Should -Be "True"
        $h.sealed | Should -Be "False"
        $h.cluster_name | Should -No -BeNullOrEmpty
        $h.cluster_id | Should -No -BeNullOrEmpty
    }
}
