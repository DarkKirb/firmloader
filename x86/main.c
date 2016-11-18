#include <kbc.h>
#include <disk.h>
#include <video.h>
#include <fatfs/ff.h>
asm(".code16gcc");
asm("mov $0x10000, %eax");
asm("mov %dx, (%eax)");
void main() {
    puts(_("FIRMloader initializes...\n"));
    doa20();
    puts(_("A20 gate enabled\n"));
    int no_parts=initDisk();
    puts(_("Found "));
    puti(no_parts);
    puts(_(" Drives\n"));
    puts(_("Initing fatfs"));
    FATFS fs;
    FIL payload;
    puti(f_mount(&fs, _("0:"), 1));
    puts(_("Opening file"));
    unsigned int retval;
    if((retval=f_open(&payload, _("BOOTMSG.TXT"), FA_READ | FA_OPEN_EXISTING)) == FR_OK) {
        puts(_("Opened file"));
        char buf[513];
        unsigned int br;
        f_read(&payload, (void*)&buf, 20, &br);
        puts(&buf);
    } else {
        puts(_("Fail"));
        puti(retval);
    }
    for(;;);
}
void putchar(char val) {
    asm("movb %0, %%al\n"  
        "movb $0x0E, %%ah\n" 
        "int $0x10\n" :  :"r"(val));
}
void puts(const char *val) {
    int i=0;
    while(val[i]) {
        if(val[i]=='\n') {
            i++;
            putchar('\r');
            putchar('\n');
        } else {
            putchar(val[i++]);
        }
    }
}
void puti(unsigned int i) {
    char buf[65];
    const char* digits = _("0123456789ABCDEF");
    char* p;
    p=buf+64;
    *p='\0';
    do {
        *--p=digits[i&0xF];
        i>>=4;
    } while(i);
    puts(p);
}
