# ps4-linux-initramfs-batocera

Custom initramfs designed specifically for the Batocera port for PlayStation 4.

This initramfs is responsible for bootstrapping the system, preparing the storage layout, and ensuring a safe, resilient boot process using an overlay-based filesystem — closely aligned with how official Batocera operates.

⚠️ This repository contains only the initramfs, not the full Batocera system.

## 🚀 Purpose

The goal of this initramfs is to provide a reliable and user-friendly installation and boot experience for Batocera on PS4 hardware, while preserving system integrity and allowing controlled persistence of system changes.

## ✨ Features

- 🔧 Unattended Installation

- Fully automated installation script

- Creates all required partitions for Batocera boot

- Automatically configures essential Batocera configuration files

- No manual partitioning required

## 🧱 OverlayFS-based Boot (Batocera-style)

- Boots the system using overlayfs, just like official Batocera

- The root filesystem remains read-only by default

Protects the system against:

- Filesystem corruption

- Unexpected power loss

## 💾 Persistent Changes (Optional)

Fully compatible with Batocera’s official tool:
```sh
batocera-save-overlay
```

- Allows saving internal system changes to the overlay on demand

- Gives the best of both worlds:

- Safe immutable system

- Optional persistence when needed

## ⚠️ Limitations & Warnings

❌ Internal HDD installation is NOT supported

✅ External USB installation only

## 💾 Storage Recommendations

For an acceptable and smooth experience, it is strongly recommended to use:

- USB 3.0 or higher

- External SSD or NVMe (USB enclosure)

Using slow USB flash drives will result in poor performance and is not recommended.

## 🧩 Compatibility

PlayStation 4:

- Fat

- Slim

- Pro (?)

Requires:

- PS4-compatible Linux kernel

- Batocera Port PS4 (42>)

- External USB boot setup

## 🛠️ Project Status

🚧 Work in progress

This initramfs is part of an ongoing Batocera PS4 port.
The main Batocera PS4 repository will be published separately once it reaches a stable state.

## Authors

better-initramfs maintained by:

- Piotr Karbowski <piotr.karbowski@gmail.com>

ps4-linux-initramfs-batocera authored by:

- JKeyRandom (https://github.com/JKeyRandom)

derived from:
   
- Ps3itaTeam (https://github.com/Ps3itaTeam)
- Nazky (https://github.com/Nazky)
- hippie68 (https://github.com/hippie68)
- noob404yt (https://github.com/noob404yt), and others.
