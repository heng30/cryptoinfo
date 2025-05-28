{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [ libGL.dev xdotool qt5.full xorg.libxcb openssl ];
  nativeBuildInputs = with pkgs; [ python3 pkg-config libsForQt5.qmake ];
}
