## Using TLS

### Certificates 

To create a CA and self-signed certificates, 

```bash
openssl genpkey -algorithm RSA -out ca-private-key.pem
openssl req -new -x509 -key ca-private-key.pem -out ca-certificate.pem -days 1 -subj /CN=vault-ca
for i in server client; do
    openssl genpkey -algorithm RSA -out $i-key.pem
    openssl req -new -key $i-key.pem -out $i-csr.pem -subj /CN=127.0.0.1
    openssl x509 -req -in $i-csr.pem -CA ca-certificate.pem -CAkey ca-private-key.pem -CAcreateserial -out $i-cert.pem \
        -days 1 -extfile tests/ca.cfg -extensions ${i}_cert
    cat ca-certificate.pem $i-cert.pem >$i-chain.pem
    openssl pkcs12 -export -in $i-chain.pem -inkey $i-key.pem -CAfile ca-certificate.pem -out $i.pfx -nodes -passout pass:  
done
```
See also [tests/ca.cfg](tests/ca.cfg). This leaves us with keys and certificates

```bash
$ ls *.pem *.pfx
ca-certificate.pem  client-cert.pem   client-csr.pem  client.pfx       server-chain.pem  server-key.pem
ca-private-key.pem  client-chain.pem  client-key.pem  server-cert.pem  server-csr.pem    server.pfx
```

### Start vault dev server with additional TLS listener

A config file, see also [tests/vault-dev-tls-config.hcl](tests/vault-dev-tls-config.hcl)

```hcl
listener "tcp" {
  address                            = "127.0.0.1:9200"
  tls_cert_file                      = "./server-cert.pem"
  tls_key_file                       = "./server-key.pem"
  tls_require_and_verify_client_cert = true
  tls_client_ca_file                 = "./ca-certificate.pem"
}
```

To start:
```bash
$ vault server -dev -dev-listen-address="127.0.0.1:8200" -config=tests/vault-dev-tls-config.hcl -dev-root-token-id root
``` 

### Set up HCVaultContext

To set up an HCVaultContext with the client certificate, use:

```posh
> $cert = Get-PfxCertificate -FilePath client.pfx
> $c = New-HCVaultContext -VaultAddr https://127.0.0.1:9200 -Certificate $cert -SkipCertificateCheck
> Get-HCVaultHealth -Ctx $c -Verbose
(...)
```