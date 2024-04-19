{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.curl
    pkgs.ghostscript
    pkgs.gnumake
    pkgs.gnused
    pkgs.sqlite
    pkgs.unzip
  ];
}
