---
layout: default
title: Homelab Provisioning
has_children: false
parent: Notebook
nav_order: 1
permalink: /homelab-provisioning
---

# Homelab Provisioning

*2025 March*<br />

![Image](docs/notebook/homelab-provisioning/00-homelab.jpg)

-----

I've grown to keep my setups stateless, simple and minimal - without fancy sw or configs.

But if you have a large homelab, or if you're doing open heart surgey on your sw stack (kernel, drivers, booting, configs), the iteration speed of re-imaging your servers gets really old.

In the bay area, I often buy up used engineering samples of the latest CPUs, GPUs, NICs and SSDs. It's often unclear how to get them to work - but I have been quite succesful just swinging at it with different OS/kernels/kernel modules/drivers/etc, and then with their specific magic incantations.

Iteration speed is the high order bit in getting things done, and I'm pleased with the below setup. 

## Overview

A simple network boot setup that:

1. By default boots into a (zero-install) diskless (ramdisk) live Ubuntu 22.04 image, with hostname set and obtained through DHCP, and `/home` mounted through NFS.
2. Optionally boots into nearly *any* supported distribution (centos, debian, ubuntu, windows, etc) either for installation or into an official "live image".

<figure>
  <figcaption>1. Initial boot splash</figcaption>
  <img src="docs/notebook/homelab-provisioning/01-boot.png" alt="Boot Process" width="640px">
</figure>

<figure>
  <figcaption>2. Custom menu that network-boots my default image in 5s</figcaption>
  <img src="docs/notebook/homelab-provisioning/02-homelab-main.png" alt="Homelab Main" width="640px">
</figure>

<figure>
  <figcaption>3. Netboot.xyz's interface to choose any distro to try or install to disk</figcaption>
  <img src="docs/notebook/homelab-provisioning/03-netboot.png" alt="Netboot Configuration" width="640px">
</figure>

<figure>
  <figcaption>4. Hundreds of supported images to try or install</figcaption>
  <img src="docs/notebook/homelab-provisioning/04-ubuntu.png" alt="Ubuntu Live Session" width="640px">
</figure>

## Prerequisites

This is a high-level overview of what you need and need to do. More concrete steps follow after.

- **DHCP and TFTP server** When you PXE boot, you send a DHCP request for an ip and boot info. Your DHCP server will then offer this - but the boot information is in the form of an endpoint (server IP) and a bootloader filename on said server. A separate TFTP server is the basic and canonical way to host this file. The easiest way to co-host a DHCP and TFTP server is to use [dnsmasq](https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html). Below I provide my configuration here. Make sure you turn off any other DHCP server on your subnet.
- **Boot file** iPXE is a popular, open source and fancy implementation of a PXE bootloader. You can build your own iPXE bootloader, but [netboot.xyz](https://netboot.xyz/) did all the work for you here. Netboot.xyz is a well maintained project with various iPXE menus, and can chainboot into dozens of different distros. I used `netboot.xyz.kpxe` for standard pc bios bootloading and `netboot.xyz.efi` for 64bit x86 EFI systems. I think this is what most homelab servers (non-ARM) use. Netboot.xyz provides amazing customization. There's a lot of docs, but not super clear. For my purposes, I did not need to recompile any iPXE files.

## Live Image: Kernel, Initramfs, Filesystem

Since you're not writing a boot image from scratch, you have to start somewhere. Ideally, you do this in a reproducible way - so you don't want to just convert your favourite server into a bootable version. As I wanted to use Ubuntu, there are only a few offically released base images: [22.* releases](https://releases.ubuntu.com/jammy/), [24.* releases](https://releases.ubuntu.com/noble/). They only provide two types of ISOs:
1. A "Desktop" image (eg `ubuntu-22.04.5-desktop-amd64.iso`). This image can do live-install but also a live-session where it layers a pre-installed image on a ramdisk.
2. A "Live Server" image (eg `ubuntu-22.04.5-live-server-amd64.iso`). This image is meant to 'live-install' but not 'live to try'.

Canonical sadly stopped provide very minimal ISOs a few years back.

I decided to go with the Desktop image of Ubuntu 22. This has a solid live ramdisk setup builtin, and the Ubuntu 22 ISO is easier to work with, because it has only one `filesystem.squashfs` filesystem overlay. The Ubuntu 24 ISO has multiple layers, which makes it not very friendly for customizing for my purposes. The Ubuntu 24 ISO consists of (consecutive layers)

1. `minimal.standard.live.squashfs` (900MB) [HIGHEST LAYER - takes presedence]
2. `minimal.standard.squashfs` (500MB) - has libreoffice and thunderbird and shit?
3. `minimal.squashfs` (1.7GB) [BOTTOM-MOST LAYER]

FYI: you can actually replace `minimal.standard.squashfs` with an empty squashfs, in which case it won't layer in any of the (imo) bloatware (thunderbird, libreoffice, etc).

Ok so lets move on with `ubuntu-22.04.5-desktop-amd64.iso`

### [Optional] Just netboot that ISO

Provided you can drop into an iPXE shell (eg through Netboot.xyz), or compile your own iPXE, you can use something like this (there are many other ways too):

**HTTP hosted; ISO on NFS**
1. Take files `casper/vmlinuz` and `casper/initrd` from your ISO and put them in the root of your TFTP server.
2. Mount your ISO somewhere (`mnt/iso`) and host it through NFS (`/etc/exports`)

```
#!ipxe
imgfree
kernel vmlinuz boot=casper netboot=nfs nfsroot=192.168.10.10:/mnt/iso ip=dhcp
initrd initrd
boot
```

### Customizing your image

The boot process is a chain of events, and your ISO encapsulates most of these components. The web is full of overly complicated steps, but I've distilled it down to the below. Even this isn't minimal, I am applying various patches with personal customizations

```
#!/bin/bash

set -e

EXPECTED_SHA256="bfd1cee02bc4f35db939e69b934ba49a39a378797ce9aee20f6e3e3e728fefbf"
IMAGE_NAME="image-$(date +%Y-%m-%d-%H%M%S)"
TMP_DIR="/tmp/${IMAGE_NAME}"

echo "Final image name: ${IMAGE_NAME}"
echo "Temporary directory: ${TMP_DIR}"

echo "deb http://archive.ubuntu.com/ubuntu jammy universe" | sudo tee /etc/apt/sources.list.d/universe.list

sudo apt-get update
sudo apt-get install -y xorriso squashfs-tools initramfs-tools patch

mkdir -p "${TMP_DIR}"

sudo mkdir -p /srv/nfs/images

# Obtain the iso
wget -O /srv/nfs/images/ubuntu-22.04.5-desktop-amd64.iso https://releases.ubuntu.com/22.04/ubuntu-22.04.5-desktop-amd64.iso

echo "${EXPECTED_SHA256} /srv/nfs/images/ubuntu-22.04.5-desktop-amd64.iso" | sha256sum -c

mkdir -p "${TMP_DIR}/extracted"
mkdir -p "${TMP_DIR}/extracted_unsquash"
mkdir -p "${TMP_DIR}/extracted_initrd"

# Extract the ISO. You can't use 7z here, xorriso is built for this.
xorriso -osirrox on -indev /srv/nfs/images/ubuntu-22.04.5-desktop-amd64.iso -extract / "${TMP_DIR}/extracted"

# Unsquash the filesystem.squashfs, the final filesystem we will eventually swap/init into.
unsquashfs -f -d "${TMP_DIR}/extracted_unsquash" "${TMP_DIR}/extracted/casper/filesystem.squashfs"

# Optionally update the squashfs filesystem, eg with apt installs etc
cp "../../boot_image/update_image.sh" "${TMP_DIR}/update_image.sh"
chmod +x "${TMP_DIR}/update_image.sh"

"${TMP_DIR}/update_image.sh" "${TMP_DIR}/extracted_unsquash"

# Unpack the initramfs so we can edit it
unmkinitramfs -v "${TMP_DIR}/extracted/casper/initrd" "${TMP_DIR}/extracted_initrd"

# Optionally add patches to the initrd and the filesystem
cp "../../boot_image/initrd.patch" "${TMP_DIR}/initrd.patch"
cp "../../boot_image/filesystem.patch" "${TMP_DIR}/filesystem.patch"

patch -p1 -d "${TMP_DIR}/extracted_initrd" < "${TMP_DIR}/initrd.patch"
patch -p1 -d "${TMP_DIR}/extracted_unsquash" < "${TMP_DIR}/filesystem.patch"

# Reconstitute the initrd using https://github.com/xuancong84/netboot/blob/main/mkinitrd.sh
"../../boot_image/mkinitrd.sh" "${TMP_DIR}/extracted_initrd" "${TMP_DIR}/new-initrd"

# Reconsistute the squashfs
mksquashfs "${TMP_DIR}/extracted_unsquash" "${TMP_DIR}/new-filesystem.squashfs"

# Put the thing back together again
cp "${TMP_DIR}/new-filesystem.squashfs" "${TMP_DIR}/extracted/casper/filesystem.squashfs"
cp "${TMP_DIR}/new-initrd" "${TMP_DIR}/extracted/casper/initrd"

sudo mv "${TMP_DIR}/extracted" "/srv/nfs/images/${IMAGE_NAME}"

echo "Boot image creation completed successfully!"
# NOTE: you do not end up with an ISO, because I like hosting the filesystem through NFS
```


## Netboot iPXE

After customizing iPXE directly, I figured I would often like to try different distro's, so I should use Netboot.xyz, which is built on iPXE itself. Netboot.xyz has a bit of an odd ansible setup to build things and customize. However, it's design is actually sound, and documentation is wide, but the docs were not super clear to me. It turns out that the design of Netboot.xyz is actually very solid and modular, and just providing the following files gave me everything I wanted:
1. Boot into a menu that by default (5s timeout) will boot into my homelab live image
2. Optionally boot from disk
3. Optionally chain into the Netboot.xyz interface.

`homelab.ipxe`
```
#!ipxe
imgfree
set nfs_host 192.168.10.12
set image_name {{ image_name }}
kernel nfs://${nfs_host}/srv/nfs/images/${image_name}/casper/vmlinuz
initrd nfs://${nfs_host}/srv/nfs/images/${image_name}/casper/initrd
imgargs vmlinuz ip=dhcp boot=casper netboot=nfs nfsroot=${nfs_host}:/srv/nfs/images/${image_name} username=tzaman systemd.unit=multi-user.target hostname=localhost textonly
boot
```

`local-vars.ipxe`
```
#!ipxe
set site_name homelab
set boot_timeout 5000
set github_user TimZaman
```

`menu.ipxe`
```
#!ipxe

:start

:main_menu
clear custom_choice
clear menu
set space:hex 20:20
set space ${space:string}

menu ${site_name}
item --gap Default:
item homelab_ipxe ${space} Homelab live boot
item local ${space} Boot from local hdd
item custom_exit ${space} Continue to netboot.xyz
isset ${menu} && set timeout 0 || set timeout ${boot_timeout}
choose --timeout ${timeout} --default homelab_ipxe menu || goto homelab_ipxe
echo ${cls}
goto ${menu} ||
goto change_menu

:change_menu
chain ${menu}.ipxe || goto error
goto main_menu

:error
echo Error occurred, press any key to return to menu ...
prompt
goto main_menu

:local
echo Booting from local disks ...
exit 1

:homelab_ipxe
echo Booting from homelab.ipxe...
chain homelab.ipxe || echo TFTP connection failed, returning to menu in 30 seconds...
sleep 30
goto main_menu

:custom_exit
chain utils.ipxe
exit
```


## DHCP, DNS, TFTP

Dnsmasq provides the core network services for our homelab. It handles DNS, DHCP, and TFTP server functions in a single lightweight package, making it perfect for homelab provisioning.

```
# DHCP Configuration
dhcp-range=192.168.10.100,192.168.10.200,48h
dhcp-option=option:router,192.168.10.1
dhcp-option=option:dns-server,192.168.10.10
dhcp-authoritative

# Static hostname assignment
dhcp-host=9c:5c:8e:bb:bb:54,id:*,192.168.10.12,beta,30d
dhcp-host=c8:7f:54:07:bc:18,id:*,192.168.10.15,epsilon,30d
dhcp-host=3c:ec:ef:de:a5:84,id:*,192.168.10.16,zeta,30d
dhcp-host=3c:ec:ef:de:a5:85,id:*,192.168.10.17,zeta,30d
dhcp-host=3c:ec:ef:de:a9:81,id:*,192.168.10.20,zeta-bmc,30d
dhcp-host=76:56:3c:52:f1:44,id:*,192.168.10.18,eta-bmc,30d
dhcp-host=74:56:3c:52:f1:43,id:*,192.168.10.19,eta,30d

# PXE Boot Configuration
enable-tftp
tftp-root=/srv/tftp
# Standard PC BIOS
dhcp-match=set:bios,60,PXEClient:Arch:00000
dhcp-boot=tag:bios,netboot.xyz.kpxe
# 64-bit x86 EFI
dhcp-match=set:efi64,60,PXEClient:Arch:00007
dhcp-boot=tag:efi64,netboot.xyz.efi

# DNS Configuration
expand-hosts
domain=lab
server=8.8.8.8
server=8.8.4.4
no-resolv
```

## Various Notes
- During boot, my client id was not deterministic (see [RFC 2132 section 9.14](https://datatracker.ietf.org/doc/html/rfc2132#section-9.14) about DHCP client identifiers). That meant that it would get assigned a dynamic IP address that wasn't tied to the actual host or the actual MAC address. So I had to set `id:*` in my dnsmasq config to force usage of MAC on the server side, and on the client side set `dhcp-identifier: mac` in your netplan.