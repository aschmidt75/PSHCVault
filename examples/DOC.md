# startup

```bash
vault server -dev -dev-root-token-id=root
export VAULT_ADDR=http://127.0.0.1:8200
```

```ps
New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
```

## auth/approle

Prepare
```bash
vault auth enable approle
vault write auth/approle/role/r1 secret_id_ttl=200m token_bound_cidrs="0.0.0.0/0" token_num_uses=1000 token_ttl=100m token_policies=default token_max_ttl=200m

vault read auth/approle/role/r1/role-id
vault write -f auth/approle/role/r1/secret-id

vault write auth/approle/login role_id=  secret_id=
```

PS
```pwsh
> $r = "<role-id>"
> $s = ConvertTo-SecureString -AsPlainText "<secure-id>"
> $auth = Get-New-HCVaultTokenByAuthWithAppRole -AppRoleID $r -SecretID $s -UpdateContext
> ConvertFrom-SecureString -AsPlainText $auth.Token
hvs.CAESIET61dPkWlKuPTl-6r1hv1p2UTDFjKlJjqsOv8REXmoeGh4KHGh2cy55ellSRUVuYkxlRnN0QmJ5dEJmaGtYd0c
```

## lookup token

Needs a token for that, or self. So extend the context with the root token and
check the token from previous step:

PS
```pwsh
> $c.VaultToken = ConvertTo-SecureString -AsPlainText ...
> Test-HCVaultToken -Token $auth.Token
```

To test the "self" token, put the token from auth into the context and use `Test-HCVaultTokenSelf`:

PS
```pwsh
> Update-HCVaultContext -Token $auth.token

> Test-HCVaultTokenSelf                                                                                                                  
accessor         : mdkM4DdlQ88cRIH2LEhR9Y2F
bound_cidrs      : {0.0.0.0/0}
(...)
```


## simple kv2

Prepare
```bash
vault secrets enable kv-v2
vault kv put -mount=secret my-secret foo=a bar=b
```

PS
```pwsh
> New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
> Update-HCVaultContext -Token (ConvertTo-SecureString -AsPlainText "root")
> Read-HCVaultSecret -SecretMountPath secret -Path my-secret

```
