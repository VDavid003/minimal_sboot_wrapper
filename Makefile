KERNEL_PATH?=kernel
DTB_PATH?=dtb

CCPREFIX?=aarch64-linux-gnu-
CC=$(CCPREFIX)gcc
CPP=$(CCPREFIX)cpp
LD=$(CCPREFIX)ld
OBJCPY=$(CCPREFIX)objcopy

OBJ=boot.o

wrapped_kernel: wrapper.o
	$(OBJCPY) -O binary $< $@

wrapper.o: $(OBJ) linker.lds $(KERNEL_PATH) $(DTB_PATH)
	$(LD) $(OBJ) -o $@ --script=linker.lds

linker.lds: linker.lds.S
	$(CPP) $< -DKERNEL_PATH=$(KERNEL_PATH) -DDTB_PATH=$(DTB_PATH) -P -o $@

%.o: %.c
	$(CC) -c -o $@ $<

clean :
	-rm *.o linker.lds wrapped_kernel
