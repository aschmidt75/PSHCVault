## Tokens

Prepare e.g.

Start the dev server instance with a default root token.

```ps
vault server -dev -dev-root-token-id root
```

Construct the context

```ps
$c = New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
$c | Update-HCVaultContext -Token (ConvertTo-SecureString -AsPlainText "<token>")
```

Issue a new token from the root token, with default role and a time to live:

```ps
$auth = New-HCVaultToken -ctx $c -Ttl 1h -Role default
Test-HCVaultToken -Ctx $c -Token $auth.Token
(...)
```

Renew the token

```ps
Update-HCVaultTokenLease -Ctx $c -Token $auth.Token
Test-HCVaultToken -Ctx $c -Token $auth.token
```

Update the current context with this token, refresh and test self. Functions take
the token of current context if not given explicitely.

```ps
$c | Update-HCVaultContext -Token $auth.Token
Update-HCVaultTokenLease -Ctx $c 
Test-HCVaultToken -Ctx $c

```