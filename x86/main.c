#include <kbc.h>
#define _(x) ((x)+0x10000)
asm(".code16gcc");
void putchar(char);
void puts(const char *);
void main() {
    puts(_("FIRMloader initializes...\n"));
    doa20();
    puts(_("A20 gate enabled\n"));
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
