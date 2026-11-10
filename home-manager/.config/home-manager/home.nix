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
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = [
    pkgs.nil
    pkgs.nixd
    pkgs.uv
    pkgs.rustup
    pkgs.home-manager
    pkgs.go
    pkgs.bun
    pkgs.zvm
    # 系統預設 node；專案需要其他版本時用 nvm 切換
    pkgs.nodejs_24
    nvm
  ];

  # 讓 ~/.nvm 下的 nvm.sh / nvm-exec 指向 nix 版 nvm（fish-nvm 與 nvm exec 都從 $NVM_DIR 讀）
  home.file.".nvm/nvm.sh".source = "${nvm}/share/nvm/nvm.sh";
  home.file.".nvm/nvm-exec".source = "${nvm}/share/nvm/nvm-exec";
}
