# Draft

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.4.0";
  }) {
    # optionally bring your own nixpkgs
    # pkgs = import <nixpkgs> {};

    # optionally specify the python version
    python = "python39";

    # optionally update pypi data revision from https://github.com/DavHau/pypi-deps-db
     pypiDataRev = "897a7471aa4e83aab21d2c501e00fee3f440e0fe";
     pypiDataSha256 = "03gnaq687gg9afb6i6czw4kzr1gbnzna15lfb26f9nszyfq3iyaj";
  };

  pyEnv = mach-nix.mkPython rec {

    requirements =  ''
        jupyterlab
        numpy<1.22
        pandas
        matplotlib
        altair
        ipywidgets
      '';

    ignoreCollisions = true;
    
    #providers.shapely = "sdist,nixpkgs";
  };
in
mach-nix.nixpkgs.mkShell {

  buildInputs = [
    pyEnv
  ] ;

  shellHook = ''
    jupyter lab --notebook-dir=~/
  '';
}