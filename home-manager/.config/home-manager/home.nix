{ config, pkgs, ... }:

{
  home.username = "chunhua";
  home.homeDirectory = "/Users/chunhua";

  # 你目前沒有 NixOS 版本，用 25.05 即可
  home.stateVersion = "25.05";

  home.packages = [
    pkgs.nil
    pkgs.nixd
  ];
}
