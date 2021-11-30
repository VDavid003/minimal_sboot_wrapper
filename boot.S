    adr	x0, dtb
    adr	x1, kernel
    b main

.global boot_kernel
boot_kernel:
    br	x4
