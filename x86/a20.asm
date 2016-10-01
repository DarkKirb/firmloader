checka20:
    pushf
    push ds
    push es
    push di
    push si
    cli
    ;Set up segments
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax
    mov di, 0x0500
    mov si, 0x0510
    mov al, byte [es:di]
    push ax
    mov al, byte [ds:si]
    push ax
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
    cmp byte [es:di], 0xFF
    pop ax
    mov byte [ds:si], al
    pop ax
    mov byte [es:di], al
    mov ax, 0
    je check_a20__exit
    mov ax, 1
check_a20__exit:
    pop si
    pop di
    pop es
    pop ds
    popf
    ret

enablea20:
    cli
    call a20wait
    mov al, 0xAD
    out 0x64, al
    call a20wait
    mov al, 0xD0
    out 0x64, al
    call a20wait2
    in al, 0x60
    push ax
    call a20wait
    mov al, 0xD1
    out 0x64, al
    call a20wait
    pop ax
    or al, 2
    out 0x60, al
    call a20wait
    mov al, 0xAE
    out 0x64,al
    call a20wait
    sti
    ret

a20wait:
    in al, 0x64
    test al,2
    jnz a20wait
    ret

a20wait2:
    in al, 0x64
    test al,1
    jnz a20wait2
    ret
