{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kanata;
in
{
  options.services.kanata = {
    enable = mkEnableOption "kanata keyboard remapping daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.kanata-with-cmd;
      description = "The kanata package to use.";
    };

    configFile = mkOption {
      type = types.str;
      default = "/Users/${config.system.primaryUser}/.config/kanata/main.kbd";
      description = "Path to the kanata configuration file.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments to pass to kanata.";
      example = [ "--log" "debug" ];
    };
  };

  config = mkIf cfg.enable {
    launchd.daemons.kanata = {
      serviceConfig = {
        ProgramArguments = [ 
          "/Users/${config.system.primaryUser}/.config/scripts/kanata-scripts/start-kanata-safely"
        ];
        
        Label = "org.nixos.kanata";
        RunAtLoad = true;
        KeepAlive = {
          SuccessfulExit = false;
        };
        
        # Run as root for input device access
        UserName = "root";
        GroupName = "wheel";
        
        # Logging
        StandardOutPath = "/var/log/kanata.log";
        StandardErrorPath = "/var/log/kanata.err";
        
        # Security and resource limits
        ProcessType = "Background";
        
        # Restart on failure
        ThrottleInterval = 15;
        
      };
    };

    # Ensure log directory exists
    system.activationScripts.extraActivation.text = ''
      # Create log file and set permissions for kanata
      touch /var/log/kanata.log
      chmod 644 /var/log/kanata.log
    '';
  };
}
