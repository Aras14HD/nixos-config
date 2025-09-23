{...}:
{
  programs.nushell = {
      shellAliases = {
      ll="eza -lah";
      cat="bat";
      grep="rg";
      nom-shell="nom-shell --run nu";
    };
    extraConfig = ''
      $env.NIXOS_CONFIG = "/home/jorim/.config/nixos"
      $env.PATH = ($env.PATH | append /home/jorim/Applications/scripts)
      $env.EDITOR = "hx"
      $env.SHELL = "nu"
      $env.config.show_banner = false
      $env.config = {
        hooks: {
          pre_prompt: [{ ||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
          }]
        }
      }
      alias "upd" = update
      def update [] {nh os switch; nh clean all -K 14d -k 5}
      def edit-config [] {run-external $env.EDITOR $env.NIXOS_CONFIG; git -C $env.NIXOS_CONFIG add .; git -C $env.NIXOS_CONFIG commit; nh os switch; git -C $env.NIXOS_CONFIG push; nh clean all -K 14d -k 5}
      def upgrade [] {nix flake update --flake $env.NIXOS_CONFIG; git -C $env.NIXOS_CONFIG add flake.lock; nh os switch; git -C $env.NIXOS_CONFIG commit -m "update flake"; git -C $env.NIXOS_CONFIG push; nh clean all -K 14d -k 5; flatpak update}
      fastfetch
    '';
  };
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;

  programs.starship = { enable = true;
    settings = {
      add_newline = true;
      character = { 
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
