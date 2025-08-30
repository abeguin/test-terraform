{
  description = "Terraform dev environment flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        unfreePkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };
        commonPackages = with pkgs; [xc cocogitto];
        terraformPackages =
          [unfreePkgs.terraform]
          ++ commonPackages
          ++ (with pkgs; [
            tflint
            awscli2
            tflint-plugins.tflint-ruleset-google
            tflint-plugins.tflint-ruleset-aws
          ]);
      in {
        formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;

        devShells.default = pkgs.mkShell {
          name = "terraform dev shell";
          packages = terraformPackages;

          shellHook = ''
            . <(cog generate-completions $(basename $SHELL))
            echo "terraform dev shell is ready with the following packages:"
            ${pkgs.lib.concatMapStringsSep "\n" (pkg: "echo - ${pkg.pname or "?"}") terraformPackages}
          '';
        };

        # expose packages
        packages = builtins.listToAttrs (map
          (pkg: {
            name = pkg.pname or "unnamed";
            value = pkg;
          })
          terraformPackages);
      };
    };
}
