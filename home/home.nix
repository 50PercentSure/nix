{ config, pkgs, inputs, ... }:

let
    user="totaltaxamount";
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
    # sysmontask= pkgs.callPackage ./custom-pkgs/sysmontask.nix {};
    # candy-icons = pkgs.callPackage ./config/icons/candy-icons.nix {};
    grimblast = pkgs.writeShellScriptBin "grimblast" ''${builtins.readFile ./config/grimblast}'';
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports =
  [
        ./modules/nvim.nix
        ./modules/hyprland.nix
        ./modules/term/term.nix

        # Flakes
        inputs.spicetify-nix.homeManagerModule
  ];

  home.username = "totaltaxamount";
  home.homeDirectory = "/home/totaltaxamount";

  # Unfree stuff/Insecure
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "qtwebkit-5.212.0-alpha4"
              ];

  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
   # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Apps
    
    (discord.override {
      withVencord = true;
    })
    gimp
    vscode-fhs
    brave
    fluent-reader
    nomacs
    bottles
    qbittorrent

    #Terminal Apps/Config
    zsh-powerlevel10k
    neofetch
    playerctl

    #Utils
    jq
    socat
    glxinfo
    bat
    openal
    qt5.full

    #Customization
    nerdfonts

    # Langs and compilers
    python3
    nodejs
    gcc

    
    # IDEs
    jetbrains.clion
    jetbrains.idea-ultimate

    # Games
    mangohud
    prismlauncher-qt5
    gamemode
    nvtop
    xfce.thunar

    # Screenshot
    grim
    slurp
    wl-clipboard
    libnotify
    grimblast
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idle1timeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # o
  #
  #  /etc/profiles/per-user/totaltaxamount/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Nord;
    colorScheme = "nord";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      songStats
      powerBar
    ];
  };
 
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  services.dunst = {
	  enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "320";
        offset = "15x9";
        indicate_hidden = true;
        shrink = false;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        gap_size = 5;
        horizontal_padding = 3;
        frame_width = 2;
        frame_color = "#34b4eb";
        separator_color = "frame";
        sort = true;
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        max_icon_size = 32;
        sticky_history = true;
        history_length = 20;
        always_run_script = true;
        progress_bar = true;
        corner_radius = 8;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
      };
      urgency_low = {
        background = "#2E3440"; # TODO: Replace all colors with theme settings
        foreground = "#88C0D0";
        timeout = 8;
      };
      urgency_normal = {
        background = "#2E3440";
        foreground = "#88C0D0";
        timeout = 8;
      };
      urgency_critical = {
        background = "#d64e4e";
        foreground = "#f0e0e0";
        frame_color = "#d64e4e";
        timeout = 0;
      };
    };
  };

  programs.git = {
    enable = true;
    userEmail = "shieldscoen@gmail.com";
    userName = "TotalTaxAmount";
  };

  gtk = {
     enable = true;
     theme = { 
        name = "Nordic";
        package = pkgs.nordic;
     };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
