to produce a table of all exported functions together with the synopsis, use:

```ps
((Get-Module PSHCVault).ExportedCommands).Values | ForEach-Object { $n = $_.Name; $s = ((Get-Help $n).synopsis); $l = "| $n | $s |"; Write-Output $l }
```