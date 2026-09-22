{ self, inputs, ... }: {
  
  flake.nixosModules.java = { pkgs, lib, ... }: {

    environment.systemPackages = with pkgs; [
      jdk
      gradle
    ];

    programs.java.enable = true;
  };

}
