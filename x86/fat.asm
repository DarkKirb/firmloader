;; FAT 16 read-only driver.
struc bpb
    .skip resb 3
    .oem resb 8
    .bytesPSector resw 1
    .sectorsPCluster resb 1
    .resSectors resw 1
    .noFAT resb 1
    .noDirent resw 1
    .noTotSecS resw 1
    .mdt resb 1
    .secPFAT resw 1
    .secPTrack resw 1
    .noHeads resw 1
    .hiddenSecs resd 1
    .noTotSecL resd 1
    .driveNum resb 1
    .flagsNT resb 1
    .signature resb 1
    .volumeID resd 1
    .volumeLabel resb 11
    .sysident resb 8
    .bootcode resb 448
    .partsig resw 1
endstruc
struc dirent
    .fname resb 11
    .attrib resb 1
    .winnt resb 1
    .creationtimtenth resb 1
    .creationtim resw 1
    .creationdat resw 1
    .accessdat resw 1
    .hicluster resw 1
    .lastmod resw 2
    .cluster resw 1
    .filesize resd 1
endstruc
;EAX contains pointer to BPB
FAT_init:
    mov [bpbptr], eax
    mov edx, eax
    add eax, bpb.noTotSecS
    xor ecx, ecx
    mov cx, [es:eax]
    jz .totSecL
    mov [total_sect], ecx
    jmp .init2
.totSecL:
    mov eax, edx
    add eax, bpb.noTotSecL
    xor ecx, ecx
    mov ecx, [es:eax]
    mov [total_sect], ecx
.init2:
    mov eax, edx
    add eax, bpb.noDirent
    mov bx, [es:eax]
    shl ebx, 5
    mov eax, edx
    add eax, bpb.bytesPSector
    add bx, word [es:eax]
    dec ebx
    ; Assume sector size is 512 bytes
    shr ebx, 9
    mov [rootdir_sect], ebx
    mov eax, edx
    add eax, bpb.noFAT
    xor cx, cx
    mov cl, [es:eax]
    mov eax, edx
    add eax, bpb.secPFAT
    xor ebx, ebx
.init2loop:
    add bx, [es:eax]
    loop .init2loop
.init2loopEnd:
    mov eax, edx
    add eax, bpb.resSectors
    add bx, [es:eax]
    add ebx, [rootdir_sect]
    mov [firstdatasect], ebx
    mov eax, edx
    add eax, bpb.sysident
    mov cx, 8
    call pascalput
    add eax, 4 
    mov bl, [es:eax]
    mov [tmp], bl
    mov cx, 1
    call pascalput
    sub bl, 0x32
    or bl, bl
    jz WrongFAT
    mov eax, bpbptr
    mov cx, 20
    call pascalput
    retn
WrongFAT:
    mov si, WrongFAT_msg
    call putstr
    cli
    hlt
ListRootDir:
    ;eax: root dir sector
    mov eax, [firstdatasect]
    sub eax, [rootdir_sect]
    add eax, 63
    mov bx, 0x3000
    mov es, bx
    mov bx, 0x0000
    call readSector
    xor bx, bx
    mov es, bx
    mov eax, 0x30000
    mov cx, 16
.loop:
    push cx
    push eax
    mov cx, 11
    call pascalput
    mov si, newline
    call putstr
    pop eax
    pop cx
    add eax, 32
    loop .loop
    mov si, ListingEnd
    call putstr
    retn
;;RODATA
WrongFAT_msg db "FIRMloader currently only supports loading from FAT 16!",13,10,0
ListingEnd db "Listing done.",13,10,0
newline db 13,10,0
;;BSS
bpbptr dd 0
total_sect dd 0
rootdir_sect dd 0
firstdatasect dd 0
tmp dd 0
