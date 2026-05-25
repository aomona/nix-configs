{ ... }:
{
  services.fail2ban = {
    enable = true;
    daemonConfig = ''
      [DEFAULT]
      findtime = 10m
      bantime = 1h
      maxretry = 5
      backend = systemd
    '';
    jails = {
      sshd = ''
        enabled = true
        port = ssh
        filter = sshd
        logpath = /var/log/auth.log
        maxretry = 5
        findtime = 600
        bantime = 3600
      '';
    };
  };
}
