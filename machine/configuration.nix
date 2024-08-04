{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # System Config
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["yoyoki"];
    substituters = [ 
      "https://mirrors.cernet.edu.cn/nixos-images/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      
      "https://cache.nixos.org"
    ];
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };
  system.stateVersion = "24.05";
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
  };
  time.timeZone = "Asia/Shanghai";

  # System software
  environment.systemPackages = with pkgs; [
    vim
    git
    bash
    zsh
    v2ray # proxy
    v2raya
    python3 # dev
  ];
  environment.variables.EDITOR = "vim";

  # Desktop
  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      excludePackages = with pkgs; [ xterm ];
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      # windowManager.bspwm.enable; # for bspwm
    };
    libinput.enable = true;
    flatpak.enable = true;
  };
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
    pkgs.gnome-user-docs
    pkgs.gnome-connections
    gnome-weather
    gnome-maps
    gnome-characters
    gnome-contacts
    epiphany
    yelp
  ];
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      	libsForQt5.fcitx5-chinese-addons
      ];
    };
  };
  fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          jetbrains-mono
          (terminus-nerdfont.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      ];
      fontconfig = {
          defaultFonts = {
              emoji = [
                  "Noto Color Emoji"
              ];
              monospace = [
                  "JetBrains Mono"
                  "Noto Sans Mono CJK SC"
                  "Symbols Nerd Font"
              ];
              sansSerif = [
                  "Noto Sans"
                  "Noto Sans CJK SC"
                  "Symbols Nerd Font"
              ];
              serif = [
                  "Noto Serif"
                  "Noto Serif CJK SC"
                  "Symbols Nerd Font"
              ];
          };
      };
  };

  # User
  programs.zsh.enable = true;
  users.users.yoyoki = {
    isNormalUser = true;
    home = "/home/yoyoki";
    description = "I am what is me.";
    extraGroups = [ "wheel" "networkmanager" ];
    password = "yoyoki";
    shell = pkgs.zsh;
  };

  # Sound for bspwm
  # sound = {
  #   enable = true;
  #   extraConfig = ''
  #     defaults.pcm.card 0
  #     defaults.ctl.card 0
  #   '';
  # };
  # hardware.pulseaudio = {
  #   enable = true;
  #   support32Bit = true;
  #   package = pkgs.pulseaudioFull;
  # };
}

