# Draft
# Environment for bulk RNAseq analysis
# no aarch64 pysam. need htseq alternative or fix
# hisat2 not compiling on aarch64

let
  pkgs = import <nixpkgs> {};

  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.4.0";
  }) {
    # optionally bring your own nixpkgs
    inherit pkgs;

    # optionally specify the python version
    python = "python39";

    # optionally update pypi data revision from https://github.com/DavHau/pypi-deps-db
     pypiDataRev = "897a7471aa4e83aab21d2c501e00fee3f440e0fe";
     pypiDataSha256 = "03gnaq687gg9afb6i6czw4kzr1gbnzna15lfb26f9nszyfq3iyaj";
  };

  pyEnv = mach-nix.mkPython rec {
    
    requirements =  ''
        jupyterlab
        numpy
        pandas
        ipywidgets
        seaborn
        matplotlib
        altair
        #htseq
      '';

    packagesExtra = with mach-nix.rPackages; [
      data_table
      limma
      edgeR
      goseq
    ];

    #providers.somepackage = "sdist,nixpkgs";
  };
in
mach-nix.nixpkgs.mkShell {

  buildInputs = [
    pyEnv
    pkgs.hisat2
  ] ;

  shellHook = ''
    jupyter lab --notebook-dir=~/
  '';
}