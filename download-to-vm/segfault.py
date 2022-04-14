import usb.core
import usb.util
import usb.backend.libusb1 as libusb1
from ctypes import *

# Find our device
dev = usb.core.find(idVendor=0x46f4, idProduct=0x0001)

if dev is None:
    raise ValueError("Device not found")

# Stop the kernel from using the device
# Avoids "device busy" error
for cfg in dev:
    for intf in cfg:
        if dev.is_kernel_driver_active(intf.bInterfaceNumber):
            try:
                dev.detach_kernel_driver(intf.bInterfaceNumber)
            except:
                sys.exit("Could not detach kernel driver from interface({0}): {1}".format(intf.bInterfaceNumber, str(e)))

# Set configuration to default
dev.set_configuration()

# Get an endpoint instance
cfg = dev.get_active_configuration()
intf = cfg[(0,0)]
ep = usb.util.find_descriptor(
    intf,
    custom_match = lambda e: usb.util.endpoint_direction(e.bEndpointAddress) == usb.util.ENDPOINT_OUT
    )
assert ep is not None

data = usb.util.create_buffer(10)

bend = libusb1.get_backend()

## The following code causes a segmentation fault ##
bend.lib.libusb_control_transfer(0x40, 0x1, 0, 0, 0, cast(data.buffer_info()[0], POINTER(c_ubyte)), data.buffer_info()[1], 10)
