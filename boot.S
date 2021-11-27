/*
 * Minimal S-Boot wrapper boot code.
 * S-Boot directly jumps to the head, so this is where it all starts.
 * Kernel and DTB are embedded inside the wrapper at link time.
 */
#ifdef POWER_KEY_BOOT
    bl wait_for_power_key
#endif
    adr	x4, kernel
    adr	x0, dtb
    /*
     * Avoid boot protocol violation. S-Boot Violates the boot protocol
     * by giving the kernel nonzero values. These are:
     * x1: 0x80000000 (Start of RAM)
     * x2: Offset of kernel start from x1
     * x3: x1 + x2
     */
    mov	x1, #0
    mov	x2, #0
    mov	x3, #0

    br	x4
