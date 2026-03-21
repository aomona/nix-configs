# PATHの追加 (リストとして扱います)
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.bun/bin")

# 証明書関連の環境変数
$env.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
$env.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
$env.TERM = "xterm-256color"
