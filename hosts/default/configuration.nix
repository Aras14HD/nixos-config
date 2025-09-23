# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.musnix.nixosModules.musnix
      inputs.sops-nix.nixosModules.sops
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.allowed-users = [ "@wheel" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.sensor.iio.enable = true; # automatic backlight

  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jorim-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      kdePackages.fcitx5-qt
      fcitx5-chinese-addons
      fcitx5-rime
      rime-data
      fcitx5-chewing
    ];
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Fingerprint service
  services.fprintd.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  musnix.enable = true;
  musnix.soundcardPciId = "c1:00.1";
  musnix.rtcqs.enable = true;

  virtualisation.libvirtd.enable = true;

  # make shebangs and many programs work by populating /bin
  services.envfs.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.flatpak.enable = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.sessionVariables = {
    FLAKE = "/home/jorim/.config/nixos";
    NH_FLAKE = "/home/jorim/.config/nixos";
    XDG_DATA_HOME = "/home/jorim/.local/share";
    EDITOR = "hx";
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/jorim/.config/sops/age/keys.txt";
    secrets.gpg_backup = {
      owner = config.users.users.jorim.name;
    };
    secrets.cloudflared-creds = {
      owner = config.users.users.jorim.name;
    };
    # secrets."ssh/id_ed25519" = {
    #   owner = config.users.users.jorim.name;
    #   path = "/home/jorim/.ssh/id_ed25519";
    # };
    # secrets."ssh/id_ed25519.pub" = {
    #   owner = config.users.users.jorim.name;
    #   path = "/home/jorim/.ssh/id_ed25519.pub";
    # };
  };

  fonts.packages = with pkgs; [
    atkinson-hyperlegible-next
    atkinson-hyperlegible-mono
    noto-fonts
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jorim = {
    isNormalUser = true;
    description = "Jorim";
    extraGroups = [ "networkmanager" "wheel" "dialout" "audio" "podman" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.krfb
      thunderbird
      distrobox
      kdePackages.filelight
      nushell
      kiwix
      fluffychat
    ];
    shell = pkgs.nushell;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "jorim" = import ./home.nix;
    };
  };

  # Security settings
  security.apparmor.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

  programs.gnupg.agent.enable = true;

  programs.gamemode.enable = true;
  programs.steam.enable = true;

  programs.adb.enable = true;

  programs.firejail.enable = true;
  programs.firejail.wrappedBinaries = {
    
  };

  programs.kdeconnect.enable = true;

  programs.partition-manager.enable = true;


  programs.virt-manager.enable = true;

  # virtualisation.waydroid.enable = true;

  programs.wireshark.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fastfetch
    helix
    pciutils
    usbutils
    git
    nil
    keepassxc
    nh
    nix-output-monitor
    nvd
    gdb
    btop
    rage
    age-plugin-yubikey
    opensc
    ffmpeg-full
    sops
    zellij
    markdown-oxide
    typst
    tinymist
    jre_minimal
    ripgrep
    dust
    deploy-rs
    framework-tool
    mpris-scrobbler
    wineWowPackages.stable
  ];

  services.syncthing = {
    enable = true;
    user = "jorim";
    dataDir = "home/jorim/Syncs";
    configDir = "/home/jorim/.config/syncthing";
  };

  # services.clamav = {
  #   daemon.enable = true;
  #   scanner.enable = true;
  #   fangfrisch.enable = true;
  #   updater.enable = true;      
  # };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "1bfe63af-b2bd-4686-a416-f9d555393dee" = {
        credentialsFile = "${config.sops.secrets.cloudflared-creds.path}";
        default = "http_status:404";
      };
    };
  };

  services.pcscd.enable = true;

  services.yubikey-agent.enable = true;

  services.cloudflare-warp.enable = true;

  services.fwupd.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
