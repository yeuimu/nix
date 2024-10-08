{ config, lib, pkgs, inputs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["yoyoki"];
    substituters = [ 
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

  wsl.defaultUser = "yoyoki";
  wsl.enable = true;

  # System Config
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  time.timeZone = "Asia/Shanghai";

  # System software
  environment.systemPackages = with pkgs; [
    vim
    git
    zsh
    wget
    curl
  ];
  environment.variables.EDITOR = "vim";
  i18n.defaultLocale = "zh_CN.UTF-8";
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  vscode-remote-workaround.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # ssh
  services.openssh.enable = true;

  # User
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.bash;
    users.yoyoki = {
        isNormalUser = true;
        home = "/home/yoyoki";
        description = "I am what is me.";
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        password = "yoyoki";
        shell = pkgs.zsh;
    };
    extraGroups.docker.members = [ "yoyoki" ];
  };

}
