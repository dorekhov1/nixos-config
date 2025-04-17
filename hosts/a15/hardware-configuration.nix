{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.asus-fa507nv
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
  };

  # Graphics configuration
  services.xserver = {
    videoDrivers = [ "amdgpu" "nvidia" ];
    enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # NVIDIA
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = false;
      nvidiaSettings = true;
      prime = {
        amdgpuBusId = "PCI:54:0:0";
        nvidiaBusId = "PCI:1:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Power management
  services.power-profiles-daemon.enable = true;
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "snd-intel-dspcfg.dsp_driver=1" ];

  # ASUS-specific features
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable NVIDIA container toolkit
  hardware.nvidia-container-toolkit.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
