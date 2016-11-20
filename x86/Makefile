AS = nasm
ASFLAGS = -f bin
CC = i686-mtgos-gcc
CFLAGS = -nostdinc -fno-builtin -I. -w -Werror  -g
LD = i686-mtgos-ld
LDFLAGS = -Tbootloader.ld
OBJCOPY = i686-mtgos-objcopy
all: stage1.bin stage2.bin

stage1.bin: boot.asm
	$(AS) $(ASFLAGS) -o $@ $^

stage2.bin: stage2.elf 
	$(OBJCOPY) -O binary --only-section=.data --set-section-flags .data=alloc $^ stage2.16
	$(OBJCOPY) -O binary --only-section=.text --set-section-flags .text=alloc $^ stage2.32
	cat stage2.16 > $@
	dd if=stage2.32 bs=1 skip=106640 >> $@
	rm stage2.16 stage2.32

stage2.elf: start.o main.o kbc.o disk.o fatfs/ff.o fatfs/diskio.o # fatfs/option/syscall.o fatfs/option/unicode.o
	$(LD) $(LDFLAGS) -o $@ $^
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^
%.o: %.S
	$(CC) -g -c -o $@ $^
