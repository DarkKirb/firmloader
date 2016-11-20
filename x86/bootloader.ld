SECTIONS {
    . = 0x0;
    .data : {
        *(otext)
        *(odata)
    }
    . = 0xA200;
    .text :  {
        *(.text)
        *(.data)
        *(.rodata)
    }
}
