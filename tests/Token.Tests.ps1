
BeforeAll {    
    $SCRIPT:roottoken = ("root" | ConvertTo-SecureString -AsPlainText)
    $cert  = Get-PfxCertificate -FilePath client.pfx
    New-HCVaultContext -VaultAddr "http://127.0.0.1:8200/" -VaultToken $SCRIPT:roottoken
    $SCRIPT:t = $null
}

$VerbosePreference = "Continue"

Describe 'Token Lifecycle' {
    It 'should successfully test self' {
        $h = Test-HCVaultTokenSelf

        $h | Should -Not -BeNullOrEmpty
        $h.id | Should -Be "root"
        $h.renewable | Should -Be "False"

        # also with this function and no params
        $h = Test-HCVaultToken

        $h | Should -Not -BeNullOrEmpty
        $h.id | Should -Be "root"
        $h.renewable | Should -Be "False"
        $h.accessor | Should -Not -BeNullOrEmpty

        # also by its accessor
        $h2 = Test-HCVaultToken -Accessor $h.accessor

        $h2 | Should -Not -BeNullOrEmpty
        $h2.accessor | Should -Be $h.accessor
        $h2.renewable | Should -Be "False"

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
        $h.id | Should -Not -Be "root"
        $h.renewable | Should -Be "True"
        $t.LeaseDuration | Should -BeGreaterThan 0
    }

    It 'should update the context with the new token' {
        Update-HCVaultContext -Token $SCRIPT:t.Token
    }

    It 'should successfully test self with the new token' {
        $h = Test-HCVaultTokenSelf

        $h | Should -Not -BeNullOrEmpty
        $h.id | Should -Not -Be "root"
        $h.renewable | Should -Be "True"
    }

    It 'should successfully revoke new token' {
        { Revoke-HCVaultTokenSelf } | Should -Not -Throw
    }

    It 'should not successfully test the revoked token' {
        { Test-HCVaultTokenSelf } | Should -Throw
    }

    It 'should create a new short-lived token' {
        Update-HCVaultContext -Token $SCRIPT:roottoken
        $t = New-HCVaultToken -Ttl 1s -Role "Default"

        $t | Should -Not -BeNullOrEmpty
        $t.Token | Should -Not -BeNullOrEmpty
        $t.Renewable | Should -Be "True"

        $SCRIPT:t = $t

        Start-Sleep -Seconds 1
    }

    It 'should successfully test that short-lived token has expired' {
        { 
            Test-HCVaultToken -Token $SCRIPT:t.Token
        } | Should -Throw -ExceptionType "System.InvalidOperationException"
    }

}

Describe 'Token Revocation Variants' {
    It 'should successfully revoke token by id' {
        $tk3 = New-HCVaultToken -Ttl 10m -Role "Default"
        Revoke-HCVaultToken -Token $tk3.Token
        ( Test-HCVaultToken -Token $tk3.Token ) | Should -Throw
    }

    It 'should successfully revoke token by accessor' {
        $tk4 = New-HCVaultToken -Ttl 10m -Role "Default"
        Revoke-HCVaultToken -Accessor $tk4.Accessor
        ( Test-HCVaultToken -Token $tk4.Token ) | Should -Throw
        ( Test-HCVaultToken -Accessor $tk4.Accessor ) | Should -Throw
    }
}
