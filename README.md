# Minimal S-Boot Wrapper
This small wrapper is designed to help booting Mainline Linux on
devices using Samsung S-Boot bootloader, especially Exynos7885 phones.
It is currently capable of starting the linked Kernel image with a
linked DTB, optionally waiting for a power button press before starting
the kernel. The dtb given to the wrapper by S-Boot is ignored, but we
currently use the ramdisk loaded in memory by S-Boot.
The advantages are that we can modify the cmdline in the dtb without
S-Boot interfering and we can plug in UART before the kernel boots after
using Download mode to flash a boot.img

## Building:
Do a simple `make` with optionally overriding the default variables.
These variables are:

**CCPREFIX**: Prefix to compiler commands. Default: "aarch64-linux-gnu-"  
**KERNEL_PATH**: Path to the kernel image. Default: "kernel"  
**DTB_PATH**: Path to the dtb. Default: "dtb"  
**CMDLINE**: Command line passed to kernel. Default: "clk_ignore_unused"  
**POWER_KEY_BOOT**: Only boot when the power key is pressed.


Example command:
`make POWER_KEY_BOOT=1 CMDLINE="clk_ignore_unused fbcon=rotate:1" KERNEL_PATH=/path/to/kernel/arch/arm64/Image DTB_PATH=/path/to/kernel/arch/arm64/boot/dts/exynos/exynos7885-jackpotlte.dtb`

**Usage:**
The resulting "wrapped_kernel" can be used instead of a kernel in a
boot.img to be flashed onto an S-Boot device. Providing a seperate
dtb in the boot image is not neccessary.
