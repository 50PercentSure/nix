
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, lib, user, pkgs, ... }:

let
  user="totaltaxamount"; #TODO: Fix this later
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      #<home-manager/nixos>
    ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  nix.settings.trusted-users = ["totaltaxamount"];

  
  # Configure  X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    videoDrivers = ["nvidia"];

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.openvpn.servers = {
     homeVPN = {config = '' config /home/totaltaxamount/VPN/home.ovpn'';};
  };
  
  hardware = {
    opengl = {
    	enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true; 
    };

    nvidia = {
      modesetting.enable = true; 
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
       };
    };

    xpadneo.enable = true;
    bluetooth.enable = true;
    steam-hardware.enable = true;
  };
  services = {
    blueman.enable = true;
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Coen Shields";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alsa-utils
    brightnessctl
    sqlite
    libnotify
  ];
  
  networking.nftables.enable = false;
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    allowedUDPPorts = [ 51820 /* Wireguard VPN */ ];
  };

  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.1.10.10/24" ];
  #     listenPort = 51820;

  #     privateKeyFile = builtins.readFile ../../secrets/wg_privatekey; # TODO: Make secrets better

  #     peers = [
  #       {
  #         publicKey = "nbxEo4I8UwZ8Q+JXeSkghGc9cdM/ziCmWoysLNrIxQI=";
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "10.1.10.101:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];

  #   };
  # };
  
  # Boot loader
  boot.kernelParams = [ 
    "video=eDP-1:1920x1080@165" # TODO: There is def a better way to do this...
    #"amd_iommu=on" # GPU passthough
   ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel"]; # Needed for vm
  boot.tmp.cleanOnBoot = true;

  services.logind.extraConfig = ''
    	HandlePowerKey=ignore
  '';

  # VMs
  virtualisation.libvirtd.enable = true;
}