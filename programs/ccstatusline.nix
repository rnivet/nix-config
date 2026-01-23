{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellScriptBin "ccstatusline" ''
      exec npx ccstatusline@latest "$@"
    '')
  ];
}
