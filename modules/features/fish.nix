{ self, inputs, ... }: {

  flake.nixosModules.fish = { pkgs, lib, ... }: {
    programs.fish = {
      enable = true;
      shellAliases = {
        fastfetch = "${pkgs.cowsay}/bin/cowsay 'Moo from NixOS!' | ${pkgs.fastfetch}/bin/fastfetch --logo -";
      };

      shellInit = ''
        if status is-interactive
          clear
          cowsay 'Moo from NixOS!' | fastfetch --logo -
        end
      '';
    };

    users.defaultUserShell = pkgs.fish;

    environment.systemPackages = with pkgs; [
      cowsay
      fastfetch
    ];
  };

}
