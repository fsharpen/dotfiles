# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "sharp.zeng";
  home.homeDirectory = "/Users/sharp.zeng";
  home.stateVersion = "24.11"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    pkgs.wezterm
    pkgs.skhd
    pkgs.zellij
    pkgs.tmux
    pkgs.sketchybar
    pkgs.atuin
    pkgs.alacritty
    pkgs.bat
    pkgs.silver-searcher
    pkgs.kubectl
    pkgs.k9s
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
   # ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
   # ".config/atuin".source = ~/dotfiles/atuin;
   # ".config/wezterm".source = ~/dotfiles/wezterm;
   # ".config/skhd".source = ~/dotfiles/skhd;
   # ".config/starship".source = ~/dotfiles/starship;
   # ".config/zellij".source = ~/dotfiles/zellij;
   # ".config/nvim".source = ~/dotfiles/nvim;
   # ".config/nix".source = ~/dotfiles/nix;
   # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
   # ".config/tmux".source = ~/dotfiles/tmux;
   # ".config/ghostty".source = ~/dotfiles/ghostty;
   # ".config/aerospace".source = ~/dotfiles/aerospace;
   # ".config/sketchybar".source = ~/dotfiles/sketchybar;
   # ".config/nushell".source = ~/dotfiles/nushell;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      eval "$(${pkgs.starship}/bin/starship init zsh)"
      export KUBECONFIG=$HOME/dotfiles/kubectl/config
    '';
  };
}
