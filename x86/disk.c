#include <disk.h>
#include <video.h>
asm(".code16gcc");
#define bootDisk (*((uint8_t*)0x10000))
#define bootsect ((uint8_t*)0x20000)
#define mbr ((partlist*)0x20000)
typedef struct {
    uint8_t size;
    uint8_t unused;
    uint16_t len;
    uint16_t off;
    uint16_t seg;
    uint64_t lba;
} __attribute__((packed)) dap;
typedef struct {
    uint8_t status;
    uint8_t chs_start[3];
    uint8_t type;
    uint8_t chs_end[3];
    uint32_t lba_start;
    uint32_t size;
}__attribute__((packed)) partent;
typedef struct {
    uint8_t bootstrap[446];
    partent entr[4];
    uint16_t magic;
} __attribute__((packed)) partlist;
int initDisk() {
    puts(_("Initializing disk...\n"));
    readSector(0x2000, 0x0000, 0, 1);
    puts(_("Read MBR...\n"));
    puti(bootsect[0x1FE]);
    puti(bootsect[0x1FF]);
    if(bootsect[0x1FE]!=0x55 || bootsect[0x1FF]!=0xAA) {
        for(;;);
    }
    int x;
    for(x=0;x<5;x++) {
        if(x==4)
            break;
        if(!mbr->entr[x].type)
            break;
    }
    return x;
}
void readSector(uint16_t tgt_seg, uint16_t tgt_off, uint64_t LBA, uint16_t size) {
    puts(_("Reading 0x"));
    puti(size);
    puts(_(" from LBA 0x"));
    puti((uint32_t)LBA);
    puts(_(" to "));
    puti(tgt_seg);
    putchar(':');
    puti(tgt_off);
    puts(_(" on drive 0x "));
    puti(bootDisk);
    putchar('\r');
    putchar('\n');
    dap *packet=(dap*)0x5000;
    packet->size=0x10;
    packet->unused=0;
    packet->len=size;
    packet->off=tgt_off;
    packet->seg=tgt_seg;
    packet->lba=LBA;
    asm("int $0x13" : : "a"(0x4200), "d"(bootDisk), "S"(0x5000));
}
uint32_t getFirstSector(int partid) {
    return mbr->entr[partid].lba_start;
}
