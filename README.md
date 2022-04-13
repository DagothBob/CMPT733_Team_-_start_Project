### REQUIREMENTS
- Using Linux
- make
- gcc
- git
- wget
- glib2.0-dev
- libfdt-devel
- gtk3-devel

On Debian-based distributions run `sudo apt-get install gcc make git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev` to get all requirements.

### INSTALLATION:
Run `make all` in the project root directory.
Build will take between 5 and 15 minutes.

### RUNNING:
Run `make run` in the project root directory.

### INSIDE THE VM:
The username and password are both "user".

Open the terminal and type
```
sudo ./segfault.py
```
to see the segmentation fault. You will also see the 4MB USB drive disappear from the desktop, as the script releases it from kernel control.

### IF YOU CANNOT DOWNLOAD THE VM IMAGE:
Run `make usb` and `make ubuntu` in the project root directory to create the virtual drives and download the Ubuntu ISO.

Run `make install` to open QEMU with the Ubuntu ISO inserted.

All default options should be fine. Make sure to do a "minimal installation" when asked, and tick the "install third-party software" box.

When you're inside the VM run
```
sudo apt update && sudo apt -y upgrade
sudo apt -y install python3 python3-pip libusb1.0 wget
python3 -m pip install pyusb
wget https://raw.githubusercontent.com/DagothBob/CMPT733_Team_-_start_Project/master/script/segfault.py
```
Then follow the instructions from the "INSIDE THE VM" part, above.