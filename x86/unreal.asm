unreal_init:
    xor ax, ax
    mov es, ax
    cli
    push ds
    lgdt [unrealgdtinfo]
    mov eax, cr0
    or al,1
    mov cr0, eax
    jmp $+2
    mov bx, 0x08
    mov ds, bx
    and al, 0xFE
    mov cr0, eax
    pop ds
    sti
    mov bx, 0x0F01
    mov eax, 0xb8000
    mov word [es:eax], bx
    retn

unrealgdtinfo:
    dw unrealgdt_end - unrealgdt -1
    dd unrealgdt

unrealgdt dd 0,0
db 0xFF, 0xFF, 0,0,0,10010010b, 11001111b, 0
unrealgdt_end:
