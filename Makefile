KERNEL_PATH?=kernel
DTB_PATH?=dtb
CMDLINE?=clk_ignore_unused

CCPREFIX?=aarch64-linux-gnu-
CC=$(CCPREFIX)gcc
CPP=$(CCPREFIX)cpp
LD=$(CCPREFIX)ld
OBJCPY=$(CCPREFIX)objcopy

DEFS=

ifdef POWER_KEY_BOOT
DEFS += -DPOWER_KEY_BOOT
endif

OBJ=boot.o main.o

.PHONY: rebuild clean

wrapped_kernel: wrapper.o
	$(OBJCPY) -O binary $< $@

wrapper.o: $(OBJ) linker.lds tmp.dtb
	$(LD) $(OBJ) -o $@ --script=linker.lds

linker.lds: linker.lds.S $(KERNEL_PATH)
	$(CPP) $< -DKERNEL_PATH=$(KERNEL_PATH) -DDTB_PATH=$(DTB_PATH) -P -o $@

%.o: %.S defs_value
	$(CC) $(DEFS) -c -o $@ $<

%.o: %.c defs_value
	$(CC) -fno-builtin $(DEFS) -c -o $@ $<

tmp.dtb: $(DTB_PATH) cmdline_value
	( dtc -O dts $(DTB_PATH) && echo "/ { chosen { bootargs = \"$(CMDLINE)\"; linux,initrd-start = <0x89000000>; linux,initrd-end = <0x890FFFFF>; }; };" ) | dtc -O dtb -o $@

defs_value: rebuild
	@echo $(DEFS) > defs.tmp
	@diff defs_value defs.tmp || cp defs.tmp defs_value
	@rm defs.tmp

cmdline_value: rebuild
	@echo $(CMDLINE) > cmdline.tmp
	@diff cmdline_value cmdline.tmp || cp cmdline.tmp cmdline_value
	@rm cmdline.tmp

clean :
	-rm *.o linker.lds wrapped_kernel cmdline_value defs_value tmp.dtb
