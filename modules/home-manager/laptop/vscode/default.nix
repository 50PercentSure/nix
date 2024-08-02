{
  pkgs,
  config,
  user,
  ...
}:
# TODO: Make the theme a real extension in nix
let
  vscodeThemeExtension = pkgs.substituteAllFiles {
    src = ../../../../dots/vscode/systemtheme;
    files = [
      "themes/System Theme-color-theme.json"
      "themes/system.tmTheme"

      "README.md"
      ".vscode/launch.json"
      ".vscodeignore"
      "package.json"
      "README.md"
      "CHANGELOG.md"
      "vsc-extension-quickstart.md"
    ];
    base00 = "#${config.colorScheme.palette.base00}";
    base01 = "#${config.colorScheme.palette.base01}";
    base02 = "#${config.colorScheme.palette.base02}";
    base03 = "#${config.colorScheme.palette.base03}";
    base04 = "#${config.colorScheme.palette.base04}";
    base05 = "#${config.colorScheme.palette.base05}";
    base06 = "#${config.colorScheme.palette.base06}";
    base07 = "#${config.colorScheme.palette.base07}";
    base08 = "#${config.colorScheme.palette.base08}";
    base09 = "#${config.colorScheme.palette.base09}";
    base0A = "#${config.colorScheme.palette.base0A}";
    base0B = "#${config.colorScheme.palette.base0B}";
    base0C = "#${config.colorScheme.palette.base0C}";
    base0D = "#${config.colorScheme.palette.base0D}";
    base0E = "#${config.colorScheme.palette.base0E}";
    base0F = "#${config.colorScheme.palette.base0F}";

    user = user;
    theme = "${config.colorScheme.name}";
    author = "${config.colorScheme.author}";
  };

  customcss = pkgs.substituteAll {
    src = ../../../../dots/vscode/customcss.css;

    focusColor = "#${config.colorScheme.palette.base05}";
  };

  settings = pkgs.substituteAll {
    src = ../../../../dots/vscode/settings.json;

    font = config.font;
    customcss = customcss.out;
  };
in
{

  programs.vscode = {
    enable = true;
    extensions =
      with pkgs.vscode-extensions;
      [
        rust-lang.rust-analyzer
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
        jnoortheen.nix-ide
        ms-vscode.makefile-tools
        esbenp.prettier-vscode
        eamodio.gitlens
        vscode-icons-team.vscode-icons
        alefragnani.bookmarks
        streetsidesoftware.code-spell-checker
        pkief.material-icon-theme
        equinusocio.vsc-material-theme

      ]
      ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "onedark";
          publisher = "bartoszmaka95";
          version = "0.2.1";
          sha256 = "sha256-j03kdtx9CqypUsBGk04mtvTvPf5Uy36c+wnJaOGFaNU=";
        }
        {
          name = "vscode-direnv";
          publisher = "Rubymaniac";
          version = "0.0.2";
          sha256 = "sha256-TVvjKdKXeExpnyUh+fDPl+eSdlQzh7lt8xSfw1YgtL4=";
        }
        {
          name = "asm-code-lens";
          publisher = "maziac";
          version = "2.6.0";
          sha256 = "sha256-4p3kizvEqqsMNJOhyKxJQ0rH3ePjstKLWb22BYy3yZk=";
        }
        #  {
        #    name = "yuck";
        #    publisher = "eww-yuck";
        #    version = "0.0.3";
        #    sha256 = "sha256-DITgLedaO0Ifrttu+ZXkiaVA7Ua5RXc4jXQHPYLqrcM=";
        #  }
      ]);
  };

  home.file.".vscode/extensions/totaltax.systemtheme-1.0.0".source = vscodeThemeExtension.out;
  xdg.configFile."Code/User/settings.json".source = settings.out;
  xdg.configFile."Code/User/keybindings.json".source = ../../../../dots/vscode/keybinds.json;
}
