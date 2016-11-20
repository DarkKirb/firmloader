.code16
.section otext
//First part: Initing protected mode
.global _start
_start:
    cli
    mov $drv+0xA000, %eax
    mov %dl, (%eax)
    lgdt gdtr+0xA000
    mov %cr0, %eax
    or $0x1, %al
    mov %eax, %cr0
    ljmp $0x8, $_start2
_readSector2:
    mov 12(%esp), %eax
    mov %ax, %si
    and $0xF, %si
    shr $0x4, %eax
    mov %ax, %ds
    mov drv, %dl
    xor %ax, %ax
    mov $0x42, %ah
    int $0x13
    mov %cr0, %eax
    or $0x1, %al
    mov %eax, %cr0
    ljmp $0x08, $_readSector3
_putc2:
    mov 4(%esp), %eax
    mov $0x0E, %ah
    int $0x10
    mov %cr0, %eax
    or $1, %al
    mov %eax, %cr0
    ljmp $0x08, $_putc3
.code32
_starth:
    jmp _start2
_readSectorh:
    jmp _readSector3
_putch:
    jmp _putc3
.section .text
_start2:
    mov $0x10, %eax
    mov %eax, %ds
    mov %eax, %es
    mov %eax, %ss
    mov $_stack, %esp
.extern main
    jmp main
.global _readSector
_readSector:
    push %edx
    push %esi
    mov %cr0, %eax
    and $0xFE, %al
    mov %eax, %cr0
    ljmp $0x1000, $_readSector2-0x10000
_readSector3:
    mov $0x10, %eax
    mov %eax, %ds
    pop %esi
    pop %edx
    ret
.global _putc
_putc:
    mov %cr0, %eax
    and $0xFE, %al
    mov %eax, %cr0
    ljmp $0x1000,$_putc2-0x10000
_putc3:
    mov $0x10, %eax
    mov %eax, %ds
    ret
.section odata
drv:
.space 1
gdt:
//NULL-descriptor
.quad 0
//32-bit code
.word 0xFFFF
.word 0x0000
.byte 0x00
.byte 0x98
.byte 0xCF
.byte 0x00
//data
.word 0xFFFF
.word 0x0000
.byte 0x00
.byte 0x92
.byte 0xCF
.byte 00
//64-bit code
.int 0
.byte 0
.byte 0x98
.byte 0x20
.byte 0

gdtr:
  .word 4 * 8
  .int gdt+0xA000
.section .data
.section .bss
.space 4096
_stack:
