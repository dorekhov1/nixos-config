# NixOS Configuration

Personal NixOS configuration with impermanence setup and automated disk management.

## Structure

```
.
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
│   ├── a15/              # Laptop configuration
│   │   ├── configuration.nix
│   │   ├── disko-config.nix
│   │   └── home.nix
│   └── common.nix        # Shared configuration
├── modules/              # Modular configurations
│   ├── desktops/        # Desktop environments
│   ├── neovim/          # Neovim configuration
│   ├── shell/           # Shell configurations
│   └── ...
└── justfile             # Command automation
```

## Initial Setup

### 1. Boot from NixOS Installation Media

### 2. Format Disks
WARNING: This will DESTROY ALL DATA on the configured disks!

```bash
# Clone this repository
git clone <repository-url> /mnt/etc/nixos

# Format disks according to disko configuration
just format-disks
```

### 3. Install NixOS
```bash
# Install NixOS with the current configuration
just install
```

### 4. Post-Installation
After rebooting into the new system:
```bash
# Rebuild the system to apply all configurations
just rebuild
```

## System Management

### Daily Operations
```bash
just rebuild            # Rebuild system configuration
just update            # Update flake inputs
just list              # List all system generations
just clean             # Clean up old generations
```

### Development
```bash
just check             # Dry-build configuration
just diff              # Show configuration changes
```

### Disk and Persistence Management
```bash
just list-persist      # List persisted files/directories
just check-persist     # Check persistence status
just clean-roots       # Clean old root snapshots
```

### Maintenance
```bash
just clean-all         # Remove all old generations
```

## Impermanence Setup

This configuration uses an impermanent root with persistent directories:

### System Persistence (/persist/system)
- /etc/nixos
- /var/log
- /var/lib/bluetooth
- /var/lib/nixos
- Other system-critical directories

### User Persistence (/persist/home)
- Downloads
- Documents
- .ssh
- Other user-specific directories

## Disk Layout

The system uses a dual-disk setup with:

### System Disk (500GB NVMe)
- Boot partition (512MB)
- Swap partition (32GB)
- Root partition with BTRFS subvolumes:
  - /root (ephemeral)
  - /persist (persistent system data)
  - /nix (nix store)

### Data Disk (1TB NVMe)
- Home partition with BTRFS subvolumes:
  - /home (ephemeral)
  - /persist_home (persistent user data)

## Troubleshooting

### System Won't Boot
1. Boot from installation media
2. Mount your system:
   ```bash
   mount /dev/root_vg/root /mnt
   mount /dev/root_vg/home /mnt/home
   ```
3. Chroot and rebuild:
   ```bash
   nixos-enter
   nixos-rebuild switch
   ```

### Persistence Issues
Check mount points and BTRFS subvolumes:
```bash
just check-persist
```
