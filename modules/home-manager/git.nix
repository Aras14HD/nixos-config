{...}: 
{
  programs.git = {
    settings = {
      user.name = "Aras14HD";
      user.email = "aras14k5@gmail.com";
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/home/jorim/.ssh/id_ecdsa_sk";
      # user.signingkey = "919386A939093546";
    };
  };
}
