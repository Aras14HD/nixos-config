{...}: 
{
  programs.git = {
    userName = "Aras14HD";
    userEmail = "aras14k5@gmail.com";
    extraConfig =  {
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/home/jorim/.ssh/id_ecdsa_sk";
      # user.signingkey = "919386A939093546";
    };
  };
}
