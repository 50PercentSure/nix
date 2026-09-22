{ self, inputs, ... }: {
    
  flake.nixosConfigurations.UTM = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.UTMConfiguration
    ];
  };

}
