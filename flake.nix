{
  description = "A /etc/NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
 #   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs,home-manager, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixosHPE = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
          inputs.determinate.nixosModules.default
            {
              nixpkgs.overlays = [
                (final: prev: {
                  stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
                  # use this variant if unfree packages are needed:
                  #stable = import nixpkgs-stable {
                  #   inherit ${prev.system};
                  #   config.allowUnfree = true;
                  # };
                })
              ];
            }
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.scott = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
      ];
    };
  };
}
