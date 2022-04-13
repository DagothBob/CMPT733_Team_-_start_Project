# This file may need to be run with sudo
# 
# Makefile to clone the QEMU 5.2.0 branch and reset the head to before the
# commit that fixes CVE-2020-14364 and build. It also sets up a virtual USB 
# device, downloads Ubuntu 18, and runs QEMU using the Ubuntu ISO.
#
# REQUIREMENTS:
# Using Linux
# make
# gcc
# git
# wget
# glib2.0-dev
# libfdt-devel
# gtk3-devel
#
# More info: https://wiki.qemu.org/Hosts/Linux
ROOT_DIR = $(shell pwd)
CORES = $$(nproc)

all: clone build run

clone:
	git clone -b stable-5.0 https://github.com/qemu/qemu.git && \
	cd qemu/ && \
	git reset --hard a575af07b8009bc51a311274c15846697b7d5f7c

build:
	mkdir -p qemu/bin/debug/native && \
	cd qemu/bin/debug/native && \
	../../../configure --enable-debug && \
	make -j$$(( $(CORES) / 2 ))

# Create a disk image of 4 gigabytes and format it ext4
usb:
	fallocate -l 8M ./qemu-virtual-usb.img && \
	sudo mkfs -t ext4 ./qemu-virtual-usb.img && \
	qemu/bin/debug/native/qemu-img create -f qcow2 test.qcow2 9G

ubuntu:
	wget https://releases.ubuntu.com/18.04/ubuntu-18.04.6-desktop-amd64.iso

# Run QEMU within a window with the Ubuntu CD inserted.
install:
	$(ROOT_DIR)/qemu/bin/debug/native/x86_64-softmmu/qemu-system-x86_64 -m 1024 -enable-kvm -drive if=virtio,file=$(ROOT_DIR)/test.qcow2,cache=none -cdrom $(ROOT_DIR)/ubuntu-18.04.6-desktop-amd64.iso

# Run QEMU within a window and with the virtual USB device inserted.
run:
	$(ROOT_DIR)/qemu/bin/debug/native/x86_64-softmmu/qemu-system-x86_64 -m 1024 -enable-kvm -drive if=virtio,file=$(ROOT_DIR)/test.qcow2,cache=none -drive if=none,id=stick,format=raw,file=$(ROOT_DIR)/qemu-virtual-usb.img -device nec-usb-xhci,id=xhci -device usb-storage,bus=xhci.0,drive=stick