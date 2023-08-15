
BeforeAll {    
    $token = ("root" | ConvertTo-SecureString -AsPlainText)
    $cert  = Get-PfxCertificate -FilePath client.pfx
    New-HCVaultContext -VaultAddr "http://127.0.0.1:8200/" -VaultToken $token 
    $SCRIPT:t = $null
}

Describe 'Token Lifecycle' {
    It 'should successfully test self' {
        $h = Test-HCVaultTokenSelf

        $h | Should -Not -BeNullOrEmpty
        $h.it | Should -Be "root"
        $h.renewable | Should -Be "False"
    }

    It 'should create a new token' {
        $t = New-HCVaultToken -Ttl 1m -Role "Default"

        $t | Should -Not -BeNullOrEmpty
        $t.Token | Should -Not -BeNullOrEmpty
        $t.Renewable | Should -Be "True"
        $t.LeaseDuration | Should -BeLessOrEqual 60
        $t.LeaseDuration | Should -BeGreaterOrEqual 50

        $SCRIPT:t = $t
    }

    It 'should successfully test the created token' {
        $t = $SCRIPT:t

        $h = Test-HCVaultToken -Token $t.Token

        $h | Should -Not -BeNullOrEmpty
        $h.it | Should -Not -Be "root"
        $h.renewable | Should -Be "True"
        $t.LeaseDuration | Should -BeGreaterThan 0
    }

    It 'should update the context with the new token' {
        Update-HCVaultContext -Token $SCRIPT:t.Token
    }

    It 'should successfully test self with the new token' {
        $h = Test-HCVaultTokenSelf

        $h | Should -Not -BeNullOrEmpty
        $h.it | Should -Not -Be "root"
        $h.renewable | Should -Be "True"
    }

    It 'should successfully revoke new token' {
        { Revoke-HCVaultTokenSelf } | Should -Not -Throw
    }

    It 'should not successfully test the revoked token' {
        { Test-HCVaultTokenSelf } | Should -Throw
    }

}
