KERNEL_PATH?=kernel
DTB_PATH?=dtb
CMDLINE?=clk_ignore_unused

CCPREFIX?=aarch64-linux-gnu-
CC=$(CCPREFIX)gcc
CPP=$(CCPREFIX)cpp
LD=$(CCPREFIX)ld
OBJCPY=$(CCPREFIX)objcopy

OBJ=boot.o

.PHONY: rebuild clean

wrapped_kernel: wrapper.o
	$(OBJCPY) -O binary $< $@

wrapper.o: $(OBJ) linker.lds tmp.dtb
	$(LD) $(OBJ) -o $@ --script=linker.lds

linker.lds: linker.lds.S $(KERNEL_PATH)
	$(CPP) $< -DKERNEL_PATH=$(KERNEL_PATH) -DDTB_PATH=$(DTB_PATH) -P -o $@

%.o: %.c
	$(CC) -c -o $@ $<

tmp.dtb: $(DTB_PATH) cmdline_value
	( dtc -O dts $(DTB_PATH) && echo "/ { chosen { bootargs = \"$(CMDLINE)\"; }; };" ) | dtc -O dtb -o $@

cmdline_value: rebuild
	@echo $(CMDLINE) > cmdline.tmp
	@diff cmdline_value cmdline.tmp || cp cmdline.tmp cmdline_value
	@rm cmdline.tmp

clean :
	-rm *.o linker.lds wrapped_kernel cmdline_value tmp.dtb
