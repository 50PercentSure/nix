{ self, inputs, ... }: {

  flake.nixosModules.python = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        pip
        requests
      ]))
    ];
  };

}
