{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.ghostscript
    pkgs.gnumake
    pkgs.gnused
    pkgs.sqlite
  ];
}
