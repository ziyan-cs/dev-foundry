# Arch VM / VMware

VM：`vm-arch`；UEFI、Secure Boot off、Bridged、4 vCPU、8 GB RAM、40 GB disk。

ISO 环境：

```bash
ls /sys/firmware/efi/efivars
lsblk
timedatectl set-ntp true
cfdisk <DISK>
```

分区：`<DISK>1` / 1G / EFI；`<DISK>2` / remaining / Linux。写入并退出后：

```bash
mkfs.fat -F32 <EFI_PARTITION>
mkfs.ext4 <ROOT_PARTITION>
mount <ROOT_PARTITION> /mnt
mkdir -p /mnt/boot
mount <EFI_PARTITION> /mnt/boot
pacstrap -K /mnt base linux linux-firmware base-devel sudo vim git openssh networkmanager man-db man-pages
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

执行：

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
bootctl install
blkid <ROOT_PARTITION>
```

依次打开、写入并保存：

```bash
vim /etc/locale.gen
vim /etc/hosts
vim /boot/loader/entries/arch.conf
vim /boot/loader/loader.conf
EDITOR=vim visudo
```

`locale.gen`：取消 `en_US.UTF-8 UTF-8` 注释。

`/etc/hosts`

```text
127.0.0.1 localhost
::1       localhost
127.0.1.1 vm-arch.localdomain vm-arch
```

`arch.conf`

```text
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=<ROOT_UUID> rw
```

`loader.conf`

```text
default arch.conf
timeout 3
console-mode max
editor no
```

`visudo`：取消 `%wheel ALL=(ALL:ALL) ALL` 注释。保存退出后：

```bash
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'vm-arch' > /etc/hostname
systemctl enable NetworkManager
useradd -m -G wheel -s /bin/bash dev
passwd dev
systemctl enable sshd
exit
umount -R /mnt
poweroff
```

移除 ISO 后登录 `dev`：

```bash
sudo systemctl enable --now sshd
```

```powershell
ssh dev@<VM_IP>
```
