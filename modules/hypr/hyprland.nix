{ config, pkgs, lib, inputs,  ... }:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    swww init &
    swww img ~/Wallpapers/ALLqk82.png &

    nm-applet --indicator &
    
    waybar &
    dunst
  '';

in
{
  home.packages = with pkgs; [
    rofi-wayland
    swww
    kitty
    alacritty
    waybar
    dunst
    networkmanagerapplet
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size =2;
      };

      decoration = {
        rounding = 10;
        shadow = {
          enabled = true;
 	  range = 10;
	  render_power = 3;
        };
      };

      animations = {
        enabled = true;
	bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
	animation = [
	  "windows, 1, 7, myBezier"
	  "border, 1, 10, default"
	  "borderangle, 1, 8, default"
	  "fade, 1, 7, default"
	  "workspaces, 1, 6, default"
	];
      };
      
      "$mod" = "SUPER";
      
      bind = [
        "$mod, RETURN, exec, alacritty"
	"$mod, Q, killactive"
	"$mod, F, fullscreen"
        "$mod, G, togglefloating"
        "$mod, R, exec, rofi -show drun"
	"$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, a, movefocus, l"
        "$mod, d, movefocus, r"
        "$mod, w, movefocus, u"
        "$mod, s, movefocus, d"
        "$mod SHIFT, a, movewindow, l"
        "$mod SHIFT, d, movewindow, r"
        "$mod SHIFT, w, movewindow, u"
        "$mod SHIFT, s, movewindow, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
	"$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, mouse_down, workspace, e+1" # Scroll though
        "$mod, mouse_up, workspace, e-1"
      ];

      bindl =
      [
	",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" # More audio
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
	",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      exec-once = ''${startupScript}/bin/start'';
    };
  };
}
