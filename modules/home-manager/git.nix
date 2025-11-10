{...}: 
{
  programs.git = {
    settings = {
      user.name = "Aras14HD";
      user.email = "aras@aras14.dev";
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/home/jorim/.ssh/id_ecdsa_sk";
    };
  };
}
