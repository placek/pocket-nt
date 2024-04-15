{ pkgs ? import <nixpkgs> {} }:
let
  db = pkgs.writeShellScriptBin "db" ''
    ${pkgs.rlwrap}/bin/rlwrap ${pkgs.sqlite}/bin/sqlite3 $@
  '';
in
pkgs.mkShell {
  buildInputs = [
    pkgs.sqlite
    db
  ];
}
