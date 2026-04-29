{ self, inputs, ... }: {

  flake.nixosModules.chromebookConfiguration = { config, pkgs, ... }: {
    imports = [
      self.nixosModules.chromebookHardware
      self.nixosModules.niri
    ];
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }];

    powerManagement.cpuFreqGovernor = "performance";
    
    networking.hostName = "nixos";
    
    networking.networkmanager.enable = true;
    time.timeZone = "America/Denver";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8"; 
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    users.users.fiftypercentsure = {
      isNormalUser = true;
      description = "50PercentSure";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      firefox
      vim
      git
      gh    
    ];

    security.rtkit.enable = true;

    hardware.enableAllFirmware = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    system.stateVersion = "25.11";
  };

}
