{ agenix, config, pkgs, ... }:

let
  user = "alexeykotomin";
  myEmacs = import ../../modules/shared/config/emacs/emacs.nix { inherit pkgs; };
in
{
  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/kanata.nix
    ../../modules/shared
     agenix.darwinModules.default
  ];

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
      trusted-substituters= [ "@admin" "${user}" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org" 
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:Jj8RWB6Rs6qJ2rFDe3P4B6LB73Dpc8s53CAw4G7xqFY="
      ];
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    myEmacs 
    agenix.packages."${pkgs.system}".default
    # texliveBasic
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; })
    ++ (import ../../modules/darwin/packages.nix { inherit pkgs; });

  # Отпечаток пальца вместо пароля везде
  security.pam.services.sudo_local.touchIdAuth = true;

  # Enable kanata keyboard remapping daemon
  services.kanata = {
    enable = true;
    configFile = "/Users/${user}/.config/kanata/config.kbd";
    # Optional: add extra args like logging level
    # extraArgs = [ "--log" "info" ];
  };
    
  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ApplePressAndHoldEnabled = false;
        AppleInterfaceStyle = "Dark";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleShowScrollBars = "Automatic";
        AppleTemperatureUnit = "Celsius";
        AppleFontSmoothing = 0;
        AppleEnableSwipeNavigateWithScrolls = false; 
        AppleSpacesSwitchOnActivate = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSUseAnimatedFocusRing = false;
        NSWindowResizeTime = 0.001;
        AppleICUForce24HourTime = true;
        
        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 1;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.trackpad.scaling" = 0.5;
        "com.apple.trackpad.forceClick" = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = false;
        orientation = "bottom";
        tilesize = 40;
        mru-spaces = false;
        expose-group-apps = true;
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "clmv";
        CreateDesktop = false;
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
        FXEnableExtensionChangeWarning = false;
        NewWindowTarget = "Home";
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerTapGesture = 2; # 0 to disable three finger tap, 2 to trigger Look up & data detectors
        TrackpadRightClick = true;
      };

      loginwindow.GuestEnabled = false;
      screencapture.target = "clipboard";

      universalaccess.reduceMotion = true;
    };
  };
}
