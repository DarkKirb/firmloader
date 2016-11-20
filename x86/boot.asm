org 0x7C00
jmp 0x0000:start
start:
    cli
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0
    sti

    mov ax, 0x0000
    mov es, ax
    mov ds, ax
    mov [bootdrv], dl
    call load
    mov dl, [bootdrv]
    mov ax, 0x1000
    mov es, ax
    mov ds, ax
    call unreal_init
    jmp 0xA00:0x0000

putstr:
    lodsb
    or al, al
    jz short putstrd
    mov ah, 0x0E
    mov bx, 0x000F
    int 0x10
    jmp putstr
putstrd:
    retn
load:
    mov cx, 4
resetloop:
    dec cx
    jz reseterror
    ;Reset
    mov ax, 0
    mov dl, [bootdrv]
    int 0x13
    jc resetloop
load2:
    mov cx, 4
    push cx
loadloop:
    pop cx
    dec cx
    jz error
    push cx
    mov ax, 0x0A00
    mov es, ax
    mov bx, 0x0
    ;Read 64 sectors
    mov ah, 2
    mov al, 59
    mov cx, 2
    mov dh, 0
    mov dl, [bootdrv]
    int 0x13
    jc loadloop
    mov si, loadmsg
    call putstr
    pop cx
    retn

reseterror:
    mov si, reseterror_msg
    call putstr
    jmp load2
error:
    mov si, error_msg
    call putstr
    cli
    hlt
    jmp $
%include "unreal.asm"
;; RODATA
reseterror_msg db "Drive couldn't be reset. Continuing.",13,10,0
error_msg db "Couldn't load data from disk. Halting.",13,10,0
loadmsg db "Loading FIRMloader",13,10,0
;; BSS
bootdrv db 0
times 510-($-$$) hlt
dw 0x55AA
