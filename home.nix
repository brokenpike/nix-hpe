{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  home.packages = with pkgs; [
  btop
  fish
  git
  git-credential-manager
  helix
  lm_sensors
 # lsp-ai
  nil
  nix-output-monitor
  vim
  ];

  programs.git = {
    enable = true;
    settings.user.name = "brokenpike";
    settings.user.email = "brokenpike@garmr.org";
    settings.credential.helper = "manager";
    settings.credential.credentialStore = "cache";
  };

  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

}
