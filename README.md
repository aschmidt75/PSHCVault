# PSHCVault

A powershell client library for [Hashicorp Vault](vaultproject.io).

![Dev CI](https://github.com/aschmidt75/PSHCVault/actions/workflows/dev-ci.yaml/badge.svg)

# Testing

[Pester](pester.dev) is used for unit-testing public commands. See [here for installation](https://pester.dev/docs/introduction/installation).

```ps
PS> Import-Module .\PSHCVault
PS> Invoke-Pester
```

# License

MIT License
Copyright (c) 2023 Andreas Schmidt

See [LICENSE](LICENSE)