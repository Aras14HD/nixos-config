{...}: 
{
  programs.git = {
    userName = "Aras14HD";
    userEmail = "aras14k5@gmail.com";
    extraConfig =  {
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      user.signingkey = "919386A939093546";
    };
  };
}
