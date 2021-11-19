OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
TARGET(binary)

INPUT(KERNEL_PATH)
INPUT(tmp.dtb)

SECTIONS
{
    .boot : {
        boot.o
    }

    .dtb ALIGN(0x1000) : {
        dtb = .;
        tmp.dtb
    }

    .kernel ALIGN(0x1000) : {
        kernel = .;
        KERNEL_PATH
    }
}
