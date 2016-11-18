AS = nasm
ASFLAGS = -f bin
CC = i686-mtgos-gcc
CFLAGS = -nostdinc -fno-builtin -I. -w -Werror -fno-unit-at-a-time -g -fno-toplevel-reorder 
LD = i686-mtgos-ld
LDFLAGS = -Ttext=0x0000 -e 0x0000 --oformat binary
all: stage1.bin stage2.bin

stage1.bin: boot.asm
	$(AS) $(ASFLAGS) -o $@ $^

stage2.bin: main.o kbc.o disk.o fatfs/ff.o fatfs/diskio.o # fatfs/option/syscall.o fatfs/option/unicode.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^
