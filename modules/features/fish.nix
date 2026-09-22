{ self, inputs, ... }: {

  flake.nixosModules.fish = { pkgs, lib, ... }: {
    programs.fish.enable = true;

    users.defaultUserShell = pkgs.fish;
  };

}
