## Creating a HCVaultContext and querying health status

Create an `HCVaultContext` object, here by also specifying the Vault API address (e.g. `http://127.0.0.1:8200` for a single dev serfver)

```ps
PS> $c = New-HCVaultContext -VaultAddr $Env:VAULT_ADDR
```

This context object stores all elements necessary to query the Vault API. It can also hold a token for authentication.

Use `Get-HCVaultHealth` to query basic health information.

```ps
PS> Get-HCVaultHealth -Ctx $c                         
                                                                                                                        
initialized                  : True
sealed                       : False
standby                      : False
performance_standby          : False
replication_performance_mode : disabled
replication_dr_mode          : disabled
server_time_utc              : 1690999445
version                      : 1.14.1
cluster_name                 : vault-cluster-addc8593
cluster_id                   : c1208353-06cd-a6eb-2f00-ae31b35a2545
```