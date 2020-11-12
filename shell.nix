# It is possible to start a shell with
# nix-shell --argstr compiler ghc8102
{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, doctest, hedgehog, hspec
      , hspec-hedgehog, stdenv
      }:
      mkDerivation {
        pname = "learn4haskell";
        version = "0.0.0.0";
        src = ./.;
        libraryHaskellDepends = [ base ];
        testHaskellDepends = [
          base doctest hedgehog hspec hspec-hedgehog
        ];
        homepage = "https://github.com/kowainik/learn4haskell";
        description = "Learn Haskell basics in 4 pull requests";
        license = stdenv.lib.licenses.mpl20;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
