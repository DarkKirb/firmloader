mov ax, 0x1000
mov ds, ax
mov es, ax
mov [bootdrv], dl
start:
    mov si, msg
    call putstr
    mov si,msg
    ;; Enable a20
    call checka20
    or ax, ax
    jnz a20_done
    ; INT 0x15 A20 enable
    mov ax,0x2401
    int 0x15
    ; Check if worked
    call checka20
    or ax, ax
    jnz a20_done
    ; Use normal A20 method
    call enablea20
    ; Check if worked
    call checka20
    or ax, ax
    jnz a20_done
    ; Last resort: Fast A20. It might cause issues with some pc's, thus we do it last
    in al, 0x92
    test al, 2
    jnz a20_done ;if bit 1 is set, a20 gate is usually enabled.
    or al, 2
    and al, 0xFE
    out 0x92, al
    call a20wait
    call checka20
    or ax, ax
    jnz a20_done
    mov si, a20_err
    call putstr
    cli
    hlt
a20_done:
    mov si, a20_init
    call putstr
    call unreal_init
    mov si, unreal_initmsg
    call putstr
    ;;Load BPB
    call getBootPartStart
    hlt
    mov ax, 0x2000
    mov es, ax
    mov bx, 0
    mov dl, [bootdrv]
    mov ah, 2
    mov al, 5
    int 0x13
    xor ax, ax
    mov es, ax
    mov si, bpb_load
    call putstr
    call unreal_init
    mov bx, 0x0F02
    mov eax, 0xB8000
    mov word [es:eax], bx
    cli
    hlt
putstr:
    lodsb
    or al, al
    jz short putstrd
    mov ah, 0x0E
    mov bx, 0x0007
    int 0x10
    jmp putstr
putstrd:
    retn

%include "a20.asm"
%include "unreal.asm"
;returns head no in dh, and cylinder and sector number in cx.
getBootPartStart:
    mov eax, 0x7C00+0x01BE+0x1
    mov dh, [es:eax]
    inc eax
    mov cx, [es:eax]
    ret

;;DATA
rmode_es dw 0x1000
pmode_es dw 0x0000
;;RODATA

msg db "Welcome to FIRMloader",13,10,0
a20_err db "A20 didn't quite work. Halting.",13,10,0
a20_init db "A20 initialized.", 13, 10, 0
unreal_initmsg db "Unreal mode initialized.",13,10,0
bpb_load db "Loaded the BIOS parameter block from disk.",13,10,0
;;BSS
bootdrv db 0
times 8*512-($-$$) hlt
