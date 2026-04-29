{ self, inputs, ... }: {

  flake.nixosConfigurations.chromebook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.chromebookConfiguration
    ];
  };

}
