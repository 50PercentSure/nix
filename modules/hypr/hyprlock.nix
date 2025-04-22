{ pkgs, config, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
	grace = 0;
        hide_cursor = true;
        no_fade_in = true;
	no_fade_out = true;
      };

      background = {
        monitor = "";
        blur_passes = 3;              # Blur strength
        noise = 0.02;                 # Subtle noise for texture
        color = "222222dd";           # Gray overlay with transparency (dd = ~87%)
      };

      input-field = {
        monitor = "";
        size = {
          width = 250;
          height = 50;
        };
        outline_thickness = 2;
        outer_color = "444444";
        inner_color = "888888";
        font_color = "000000";
        placeholder_text = "<i>Input Password...</i>";
        placeholder_color = "888888";
        position = "0, 0";
        halign = "center";
        valign = "center";
	fade_on_empty = false;
      };
      

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 32;
          position = "0, 100";
          color = "ffffff";
	  halign = "center";
	  valign = "center";
        }
      ];
    };
  };
}

