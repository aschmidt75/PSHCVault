listener "tcp" {
  address                            = "127.0.0.1:9200"
  tls_cert_file                      = "./server-cert.pem"
  tls_key_file                       = "./server-key.pem"
  tls_require_and_verify_client_cert = true
  tls_client_ca_file                 = "./ca-certificate.pem"
}