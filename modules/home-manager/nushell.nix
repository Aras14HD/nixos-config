{...}:
{
  programs.nushell = {
      shellAliases = {
      ll="eza -lah";
      ls="eza";
      cat="bat";
      grep="rg";
    };
    extraConfig = ''
      $env.NIXOS_CONFIG = "/home/jorim/.config/nixos"
      $env.PATH = ($env.PATH | append /home/jorim/Applications/scripts)
      $env.EDITOR = "hx"
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
      def update [] {nh os switch; nh clean all -K 14d -k 5}
      def edit-config [] {run-external $env.EDITOR $env.NIXOS_CONFIG; git -C $env.NIXOS_CONFIG add .; git -C $env.NIXOS_CONFIG commit; git -C $env.NIXOS_CONFIG push; nh os switch; nh clean all -K 14d -k 5}
      def upgrade [] {nix flake update --flake $env.NIXOS_CONFIG; git -C $env.NIXOS_CONFIG add flake.lock; git -C $env.NIXOS_CONFIG commit -m "update flake"; git -C $env.NIXOS_CONFIG push; nh os switch; nh clean all -K 14d -k 5; flatpak update}
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
