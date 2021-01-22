
CROSS_COMPILE = arm-none-eabi-

# Use our cross-compile prefix to set up our basic cross compile environment.
CC      = $(CROSS_COMPILE)gcc
LD      = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

CFLAGS = \
	-mtune=arm7tdmi \
	-mlittle-endian \
	-fno-stack-protector \
	-fno-common \
	-fno-builtin \
	-ffreestanding \
	-std=gnu99 \
	-Werror \
	-Wall \
	-Wno-error=unused-function \
	-fomit-frame-pointer \
	-g \
	-Os

LDFLAGS =

all: intermezzo.bin bootstrap.bin

ENTRY_POINT_ADDRESS := 0x4000A000

# Provide the definitions used in the intermezzo stub.
DEFINES := \
	-DENTRY_POINT_ADDRESS=$(ENTRY_POINT_ADDRESS)

intermezzo.elf: intermezzo.o
	$(LD) -T intermezzo.lds --defsym LOAD_ADDR=$(ENTRY_POINT_ADDRESS) $(LDFLAGS) $^ -o $@

intermezzo.o: intermezzo.S
	$(CC) $(CFLAGS) $(DEFINES) $< -c -o $@

bootstrap.elf: bootstrap.o kernel.o
	$(LD) -T fusee.lds --defsym LOAD_ADDR=$(ENTRY_POINT_ADDRESS) $(LDFLAGS) $^ -o $@
kernel.o: kernel.c
	$(CC) $(CFLAGS) $(DEFINES) $< -c -o $@
bootstrap.o: bootstrap.S 
	$(CC) $(CFLAGS) $(DEFINES) $< -c -o $@

bootstrap.bin: bootstrap.elf
	$(OBJCOPY) -v -O binary $< $@

clean:
	rm -f *.o *.elf *.bin

.PHONY: all clean
