{ pkgs, config, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
	hide_cursor = true;
	no_fade_in = false;
      };

      background = [
	{
	  monitor = "";
	  color = "111111";
	}
      ];

      input-field = [
	{
	  monitor = "";
	  size = {
	    width = 200;
	    height = 50;
	  };
	outline_thickness = 2;
	outer_color = "000000";
	inner_color = "ffffff";
	font_color = "000000;
	placerholder_text = "<password>";
	placeholder_color = "888888";
	position = {
	  x = 0;
	  y = -100;
	};
	halign = "center";
	valign = "center";
      };
    ];
  };
}
