{ config, pkgs, ... }:

let
  # nvm 已從 nixpkgs 移除，這裡自行打包（nvm 本身只是一組 shell script）
  nvm = pkgs.stdenv.mkDerivation rec {
    pname = "nvm";
    version = "0.40.8";
    src = pkgs.fetchFromGitHub {
      owner = "nvm-sh";
      repo = "nvm";
      rev = "v${version}";
      hash = "sha256-24FP1brAAyWu+Q0Dk+Y4aXgdCBon9GkBXgFaGXBO7sc=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/nvm
      cp -r $src/. $out/share/nvm/
    '';
  };
in
{
  home.username = "chunhua";
  home.homeDirectory = "/Users/chunhua";

  # 你目前沒有 NixOS 版本，用 25.05 即可
  home.stateVersion = "25.05";

  home.packages = [
    pkgs.nil
    pkgs.nixd
    pkgs.uv
    pkgs.rustup
    pkgs.home-manager
    nvm
  ];
}
