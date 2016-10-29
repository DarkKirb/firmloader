#include <kbc.h>
#include <io.h>
void doa20() {
    if(checka20())
        return;
    biosa20();
    if(checka20())
        return;
    legacya20();
    if(checka20())
        return;
    fasta20();
    if(checka20())
        return;
    for(;;);
}
int checka20() {
    char* a=(char*)0x500;
    char* b=(char*)0x100500;
    char tmpa=*a,tmpb=*b;
    int enabled=0;
    *b=~tmpb;
    if(*a==tmpa) {
        enabled=1;
    }
    *a=tmpa;
    *b=tmpb;
    return enabled;
}
void biosa20() {
    asm("int $0x15" : : "a"(0x2401)); //Enable a20 gate
}
static void a20wait1() {
    while(inb(0x64)&2);
}
static void a20wait2() {
    while(inb(0x64)&1);
}
static void sendCommand(uint8_t command) {
    a20wait1();
    outb(0x64, command);
}
static uint8_t readByteFromKBC() {
    a20wait2();
    return inb(0x60);
}
void legacya20() {
    cli();
    sendCommand(0xAD);
    sendCommand(0xD0);
    uint8_t tmp = readByteFromKBC();
    tmp |= 2;
    sendCommand(0xD1);
    sendCommand(tmp);
    sendCommand(0xAE);
    sti();
}
void fasta20() {
    uint8_t tmp = inb(0x92);
    tmp |= 0x2;
    tmp &= 0xFE;
    outb(0x92, tmp);
    a20wait2();
}
