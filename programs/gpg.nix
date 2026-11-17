{pkgs, ...}: {
  # GnuPG with the macOS pinentry, so passphrase prompts show a native
  # dialog and can be cached in the Keychain.
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
  };
}
