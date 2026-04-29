{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };
  };
  
  perSystem = { pkgs, lib, self', ... }:
    let
      colors = builtins.fromJSON (builtins.readFile ./rosey-amoled.json);

      theme = colors.dark;
    in
    {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
	];         

        input.keyboard.xkb.layout = "us";

        layout = {
	  gaps = 3;
	  focus-ring = {
	    width = 3;
	    active-color = theme.mPrimary;
	  };

	  border = {
	    width = 3;
	    active-color = theme.mSurfaceVariant;
	  };
	};
 
        binds = {
	  "Mod+S".spawn-sh = 
	    "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
          "Mod+RETURN".spawn-sh = lib.getExe pkgs.kitty;          
          
	  "Mod+Q".close-window = {};
	  "Mod+F".maximize-column = {};
	  "Mod+G".fullscreen-window = {};
	  "Mod+Shift+F".toggle-window-floating = {};
	  "Mod+C".center-column = {};

	  "Mod+Left".focus-column-left = {};
	  "Mod+Right".focus-column-right = {};
	  "Mod+Up".focus-window-up = {};
	  "Mod+Down".focus-window-down = {};

	  "Mod+Shift+Left".move-column-left = {};
	  "Mod+Shift+Right".move-column-right = {};
	  "Mod+Shift+Up".move-window-up = {};
	  "Mod+Shift+Down".move-window-down = {};

	  "Mod+1".focus-workspace = "w0";
	  "Mod+2".focus-workspace = "w1";
	  "Mod+3".focus-workspace = "w2";
	  "Mod+4".focus-workspace = "w3";
	  "Mod+5".focus-workspace = "w4";
	  "Mod+6".focus-workspace = "w5";
	  "Mod+7".focus-workspace = "w6";
	  "Mod+8".focus-workspace = "w7";
	  "Mod+9".focus-workspace = "w8";
	  "Mod+0".focus-workspace = "w9";

	  "Mod+Shift+1".move-column-to-workspace = "w0";
	  "Mod+Shift+2".move-column-to-workspace = "w1";
	  "Mod+Shift+3".move-column-to-workspace = "w2";
	  "Mod+Shift+4".move-column-to-workspace = "w3";
	  "Mod+Shift+5".move-column-to-workspace = "w4";
	  "Mod+Shift+6".move-column-to-workspace = "w5";
	  "Mod+Shift+7".move-column-to-workspace = "w6";
	  "Mod+Shift+8".move-column-to-workspace = "w7";
	  "Mod+Shift+9".move-column-to-workspace = "w8";
	  "Mod+Shift+0".move-column-to-workspace = "w9";

	  "Mod+F10".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
	  "Mod+F9".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

	  "Mod+Ctrl+Left".set-column-width = "-5%";
	  "Mod+Ctrl+Right".set-column-width = "+5%";
	  "Mod+Ctrl+Up".set-window-height = "-5%";
	  "Mod+Ctrl+Down".set-window-height = "+5%";
        };
      };
    };
  };
        
}
