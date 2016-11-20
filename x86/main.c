#include <kbc.h>
#include <disk.h>
#include <video.h>
#include <fatfs/ff.h>

asm("mov $0x10000, %eax");
asm("mov %dx, (%eax)");
void main() {
    puts("FIRMloader initializes...\n");
    doa20();
    puts("A20 gate enabled\n");
    int no_parts=initDisk();
    puts("Found ");
    puti(no_parts);
    puts(" Drives\n");
    puts("Initing fatfs");
    FATFS fs;
    FIL payload;
    puti(f_mount(&fs, "0:", 1));
    puts("Opening file");
    unsigned int retval;
    if((retval=f_open(&payload, "bootmsg.txt", FA_READ | FA_OPEN_EXISTING)) == FR_OK) {
        puts("Opened file");
        char buf[513];
        unsigned int br;
        f_read(&payload, (void*)&buf, 20, &br);
        puts(&buf);
    } else {
        puts("Fail");
        puti(retval);
    }
    for(;;);
}
void _putc(char x);
void putchar(char val) {
    _putc(val);
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
    const char* digits = "0123456789ABCDEF";
    char* p;
    p=buf+64;
    *p='\0';
    do {
        *--p=digits[i&0xF];
        i>>=4;
    } while(i);
    puts(p);
}
