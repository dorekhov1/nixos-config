{ config, ... }: 

{
  disko.devices = {
    disk = {
      system = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Micron_2400_MTFDKBA512QFM_22413CD7F126";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              name = "swap";
              size = "32G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
      data = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KXG50ZNV1T02_NVMe_TOSHIBA_1024GB_18AS1097TYAT";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "data_vg";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                };
                "/persist" = {
                  mountOptions = ["subvol=persist" "noatime"];
                  mountpoint = "/persist";
                };
                "/nix" = {
                  mountOptions = ["subvol=nix" "noatime"];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
      data_vg = {
        type = "lvm_vg";
        lvs = {
          home = {
            size = "100G";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "subvol=home"
                    "noatime"
                  ];
                };
                "/persist_home" = {
                  mountpoint = "/persist/home";
                  mountOptions = [
                    "subvol=persist_home" 
                    "noatime"
                  ];
                };
              };
            };
          };
          userdata = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/data" = {
                  mountpoint = "/data";
                  mountOptions = [
                    "subvol=data"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
