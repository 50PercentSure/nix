{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
	
    style = ''
      window#waybar {
	margin-top: 10px;
	margin-left: 10px;
	margin-right: 10px;
	border-radius: 12px;
	background-color: rgba(30, 30, 30, 0.95);
      }

      * {
	border-radius: 0px;
	font-family: "JetBrains Mono", "Font Awesome 6 Free";
	font-size: 14px;
	color: #ffffff;
      }

      #workspaces {
	padding: 0 10px;
	background-color: transparent;
        margin: 4px 6px;
	border-radius: 8px;
      }

      #workspaces button {
	padding: 4px 8px;
	margin: 2px;
	background: #333333;
	color: #ffffff;
	border: none;
	border-radius: 4px;
      }

      #workspaces button.active {
	background-color: #cccccc;
      }

      #clock {
	padding: 0 10px;
	background-color: #2c2c2c;
      }

      #pulseaudio {
	padding: 0 10px;
	background-color: #2f2b26;
      }

      #cpu {
	padding: 0 10px;
	background-color: #3a3a3a;
      }

      #memory {
	padding: 0 10px;
	background-color: #4b605e;
      }

      #network {
	padding: 0 10px;
	background-color: #5a4f44;
      }

      #battery {
	margin-right: 20px;
	padding: 0 10px;
	background-color: #6b7b73;
      }

      .module {
	margin: 0 4px;
      }
    '';    

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "cpu" "memory" "network" "battery"];
        
        clock = {
	  interval = 1;
          format = "{:%H:%M:%S}";
          rotate = 0;
	  format-alt = "{  %d·%m·%y}";
          tooltip-format = "<span>{calendar}</span>";
	  calendar = {
	    mode = "month";
	    format = {
	      months = "<span color='#ff6699'><b>{}</b></span>";
	      days = "<span color='#cdd6f4'><b>{}</b></span>";
	      weekdays = "<span color='#7CD37C'><b>{}</b></span>";
              today = "<span color='#ffcc66'><b>{}</b></span>";
	    };	
          };
        };

        pulseaudio = {
	  format = "{icon} {volume}%";
	  format-bluetooth = "{icon} 󰂰 {volume}%";
	  format-muted = "󰖁";
	  format-icons = {
	    headphone = "";
	    hands-free = "";
	    headset = "";
	    phone = "";
	    portable = "";
	    car = "";
	    default = [
	      "" "" "󰕾" ""
	    ];
	    ignored-sinks = [
	      "Easy Effects Sink"
	    ];
	  };
	  tooltip-format = "{icon} {desc} | {volume}%";     
        };
 
        cpu = {
	  format = "{usage}%";
	  format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        };

        network = {
	  format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ Disconnected";
	};

	battery = {
	  # interval = 5;
	  align = 0;
	  rotate = 0;
	  # bat = "BAT1";
	  # adapter = "ACAD";
	  full-at = 100;
	  design-capacity = false;
	  states = {
	    good = 95;
	    warning = 30;
	    critical = 15;
	  };
	  format = "{icon} {capacity}%";
	  format-charging = " {capacity}%";
	  format-plugged = "󱘖 {capacity}%";
	  format-alt-click = "click";
	  format-full = "{icon} Full";
	  format-icons = [
	    "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"
	  ];
	  format-time = "{H}h {M}min";
	  tooltip = true;
	  tooltip-format = "{timeTo} {power}w";
	};
	
	tray = {
	  icon-size = 16;
	  spacing = 10;
	};
      };
    };
  };
}
