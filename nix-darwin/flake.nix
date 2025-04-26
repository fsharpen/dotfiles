{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.vim
            pkgs.direnv
            pkgs.sshs
            pkgs.glow
            pkgs.nushell
            pkgs.carapace
            pkgs.starship
            pkgs.nixfmt-rfc-style
            pkgs.television
          ];

          environment.etc."pam.d/sudo_local".text = ''
            # Managed by Nix Darwin
            auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
            auth       sufficient     pam_tid.so
          '';

          nix.settings.experimental-features = "nix-command flakes";
          programs.zsh.enable = true;  # default shell on catalina
          #programs.television.enable = true;
          #programs.television.enableZshIntegration = true;

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";

          #security.pam.services.sudo_local.touchIdAuth = true;

          users.users."sharp.zeng".home = "/Users/sharp.zeng";
          home-manager.backupFileExtension = "backup";

          environment.variables = {
            STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml";
          };

          system.defaults = {
            dock.autohide = true;
            dock.mru-spaces = false;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            screencapture.location = "~/Pictures/screenshots";
            screensaver.askForPasswordDelay = 10;
          };

          # Homebrew needs to be installed on its own!
          homebrew.enable = true;
          homebrew.casks = [
            "font-meslo-lg-nerd-font"
"dbeaver-community"
            #"wireshark"
            #"google-chrome"
          ];
          homebrew.brews = [
            #"imagemagick"
          ];
        };
    in
    {
      darwinConfigurations."LMK75JJ3F" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."sharp.zeng" = import ./home.nix;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."LMK75JJ3F".pkgs;
    };
}
