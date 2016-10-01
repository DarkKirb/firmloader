AS = nasm
ASFLAGS = -f bin
all: stage1.bin stage2.bin

stage1.bin: boot.asm
	$(AS) $(ASFLAGS) -o $@ $^

stage2.bin: stage2.asm
	$(AS) $(ASFLAGS) -o $@ $^
