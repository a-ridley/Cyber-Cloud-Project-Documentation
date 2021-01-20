---
id: qcow2-techniques
title: Convert Images to QCOW2
---

```
# if your images are in ova format, first extract them:
tar -xvf librenms-centos-7.6-x86_64.ova

qemu-img convert -p -O qcow2 Kali-Linux-2016.1-vm-amd64/Kali-Linux-2016.1-vm-amd64-s00*.vmdk kali-for-stack.qcow2

scp -p kali-rolling.qcow2 root@192.168.128.18:/home/temp/kali-rolling.qcow2

glance image-create --progress --name "<imagename>" --file <filename> --disk-format qcow2 --container-format bare --visibility public 
```
## using guestfish to modify qcow2 images
```
openssl passwd -1 root
$1$fsEss800$XVE9wrYXvjMM4AMJjhqFh.

guestfish --rw -a /var/lib/libvirt/images/debian9-vm1.qcow2

><fs> launch
><fs> list-filesystems
><fs> mount /dev/sda1 /
><fs> mount /dev/sda1 /
> find /etc/shadow and replace: root:<yourpasswordhashhere>:17572:0:99999:7:::
><fs> sync
><fs> quit

```
## modifying a cloud config file
```
#cloud-config
users:
  - default
  - name: root
    gecos: root
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    lock_passwd: false
    passwd: $1$root$9gr5KxwuEdiI80GtIzd.U0
 
#cloud-config
#create additional user
users:
 - default
 - name: test
 gecos: Test User
 sudo: ALL=(ALL) NOPASSWD:ALL
```
