org 0x10000
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
    mov si, unreal_initmsg
    call putstr
    ;;Load BPB
    call getBootPartStart
    mov bx, 0x2000
    mov es, bx
    mov bx, 0x0000
    call readSector
    xor ax, ax
    mov es, ax
    mov si, bpb_load
    call putstr
    mov bx, 0x0F02
    mov eax, 0xB8000
    mov word [ds:eax], bx
    mov eax, 0x20000
    call FAT_init
    mov si, fat_inited
    call putstr
    call ListRootDir
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
pascalput:
    push ax
    push bx
.loop:
    push eax
    mov al, [es:eax]
    mov ah, 0x0E
    mov bx, 0x000F
    int 0x10
    pop eax
    inc eax
    loop .loop
    pop bx
    pop ax
    retn

%include "a20.asm"
%include "unreal.asm"
%include "fat.asm"
;returns head no in dh, and cylinder and sector number in cx.
getBootPartStart:
    mov eax, 0x7DC6
    mov ebx, 63
    mov [partlba], ebx
    mov eax, ebx
    ret
;Reads one sector from LBA eax and stores it at es:bx
readSector:
    mov cx, 16
    mov [dap+DAP.size], cx
    xor cx, cx
    mov [dap+DAP.unused], cx
    mov cx, 1
    mov [dap+DAP.readsec], cx
    mov [dap+DAP.offset], bx
    mov cx, es
    mov [dap+DAP.segment], cx
    mov [dap+DAP.lba], eax
    mov si, dap
    mov dl,[bootdrv]
    mov ah, 0x42
    int 0x13
    retn

;;DATA
rmode_es dw 0x1000
pmode_es dw 0x0000
;;RODATA

msg db "Welcome to FIRMloader",13,10,0
a20_err db "A20 didn't quite work. Halting.",13,10,0
a20_init db "A20 initialized.", 13, 10, 0
unreal_initmsg db "Unreal mode initialized.",13,10,0
bpb_load db "Loaded the BIOS parameter block from disk.",13,10,0
fat_inited db "Initialized FAT16 driver.",13,10,0
;;BSS
bootdrv db 0
partlba dd 0, 0

struc DAP
    .size resb 1
    .unused resb 1
    .readsec resw 1
    .offset resw 1
    .segment resw 1
    .lba resd 2
endstruc
dap:
    db 0x10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
times 62*512-($-$$) hlt
