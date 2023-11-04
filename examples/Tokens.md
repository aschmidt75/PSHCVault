## Tokens

Prepare e.g.

Start the dev server instance with a default root token.

```ps
> vault server -dev -dev-root-token-id root
```

Construct the context

```ps
> New-HCVaultContext -VaultAddr http://127.0.0.1:8200/
> Update-HCVaultContext -Token (ConvertTo-SecureString -AsPlainText "<token>")
```

Issue a new token from the root token, with default role and a time to live:

```ps
> $auth = New-HCVaultToken -Ttl 1h -Role default
> Test-HCVaultToken -Token $auth.Token
(...)
```

Renew the token

As "renew" is not an allowed verb in Powershel commandlets, this is described as updating the token lease:

```ps
> Update-HCVaultTokenLease -Token $auth.Token
> Test-HCVaultToken -Token $auth.token
```

Update the current context with this token, refresh and test self. Functions take
the token of current context if not given explicitely.

```ps
> Update-HCVaultContext -Token $auth.Token
> Update-HCVaultTokenLease                       # renews the token in the current context
> Test-HCVaultTokenSelf                          # tests the token in the current context
```

Revoke a token

A token can be revoked by using the token itself, its accessor or the token stored in 
the current context.

```ps
> $tk = New-HCVaultToken -Ttl 10m -Role "Default"
> Revoke-HCVaultToken -Token $tk3.Token
```

or

```ps
> Revoke-HCVaultToken -Accessor $tk.Accessor
```

or revoking the self-token

```ps
> Revoke-HCVaultToken
```

Showing Token Accessors (requires sudo capabilities)

```ps
> $ta = Show-HCVaultTokenAccessors
$ta.data.keys
qAz0DhFcaWH7xeRZ5Vu54fqu
LKDJtWtCiGP8oIWqjnCIKmIK
ghayNMY32Ixwl7HUMzrDowgl
(...)
```
