{...}:
{
  programs.nushell = {
      shellAliases = {
      ll="eza -lah";
      ls="eza";
      cat="bat";
      grep="rg";
      update="nh os switch; nh clean all -K 14d -k 5";
      edit-config="cd /home/jorim/.config/nixos && $EDITOR && git add . && git commit && git push && nh os switch; nh clean all -K 14d -k 5; cd -";
      upgrade="nix flake update --flake /home/jorim/.config/nixos && git -C /home/jorim/.config/nixos add flake.lock && git -C /home/jorim/.config/nixos commit -m \"update flake\" && git -C /home/jorim/.config/nixos push && nh os switch; nh clean all -K 14d -k 5; flatpak update;";
    };
    envExtra = "export EDITOR=hx\nexport PATH=$PATH:/home/jorim/Applications/scripts";
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = { enable = true;
      settings = {
        add_newline = true;
        character = { 
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
