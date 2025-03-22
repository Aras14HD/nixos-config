{...}:
{
  programs.nushell = {
      shellAliases = {
      ll="eza -lah";
      ls="eza";
      cat="bat";
      grep="rg";
      update="nh os switch; nh clean all -K 14d -k 5";
      edit-config="cd /home/jorim/.config/nixos; hx; git add .; git commit; git push; nh os switch; nh clean all -K 14d -k 5; cd -";
      upgrade="nix flake update --flake /home/jorim/.config/nixos; git -C /home/jorim/.config/nixos add flake.lock; git -C /home/jorim/.config/nixos commit -m \"update flake\"; git -C /home/jorim/.config/nixos push; nh os switch; nh clean all -K 14d -k 5; flatpak update;";
    };
    extraConfig = ''
      $env.PATH = ($env.PATH | append /home/jorim/Applications/scripts)
      $env.EDITOR = "/bin/hx"
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
