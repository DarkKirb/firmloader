SECTIONS {
    . = 0x0500;
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
        *(.rodata)
        *(.bss)
    }
}
