hostname := "a15"
flake := "."
disk_config := "./hosts/a15/disko-config.nix"

rebuild:
    @echo "Rebuilding NixOS configuration..."
    nixos-rebuild switch --flake {{flake}} --use-remote-sudo --option eval-cache false --show-trace

update:
    @echo "Updating flake inputs..."
    nix flake update

list:
    @echo "Listing all generations..."
    nix-env --list-generations
    nixos-rebuild list-generations

clean *ARGS:
    @echo "Cleaning up old generations..."
    sudo nix-collect-garbage {{ARGS}}

clean-all: && clean
    @echo "Removing all old generations..."
    sudo nix-collect-garbage -d

format-disks:
    #!/usr/bin/env bash
    echo "WARNING: This will DESTROY ALL DATA on the disks configured in disko-config.nix"
    echo "Are you sure you want to continue? (y/N)"
    read answer
    if [ "$answer" = "y" ]; then
        sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko {{disk_config}}
    else
        echo "Aborted."
    fi

list-persist:
    @echo "Listing persisted directories..."
    ls -la /persist/system
    @echo "\nListing persisted home directories..."
    ls -la /persist/home

check-persist:
    @echo "Checking persistence status..."
    findmnt -t btrfs | grep persist
    @echo "\nChecking BTRFS subvolumes..."
    sudo btrfs subvolume list /

clean-roots:
    @echo "Cleaning old root snapshots..."
    sudo find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30 -exec rm -rf {} \;

check:
    @echo "Checking NixOS configuration..."
    nixos-rebuild dry-build --flake {{flake}}

diff:
    @echo "Showing changes between current and new configuration..."
    nixos-rebuild build --flake {{flake}} --show-trace
    nvd diff /run/current-system result

install:
    #!/usr/bin/env bash
    echo "WARNING: This will install NixOS with the current configuration"
    echo "Make sure you have formatted the disks first with 'just format-disks'"
    echo "Continue? (y/N)"
    read answer
    if [ "$answer" = "y" ]; then
        sudo nixos-install --root /mnt --flake {{flake}}#{{hostname}}
    else
        echo "Aborted."
    fi

edit-secrets:
  sops secrets/secrets.yaml

help:
    @just --list

default: help
