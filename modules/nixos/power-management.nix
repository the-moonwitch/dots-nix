{
  flake.modules.nixos.power-management = {
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "schedutil";
    };
  };
}
