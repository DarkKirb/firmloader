#pragma once
#include <stdint.h>
__attribute__((always_inline))
static inline void outb(uint16_t port, uint8_t val) {
    asm volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}
__attribute__((always_inline))
static inline void outw(uint16_t port, uint16_t val) {
    asm volatile("outw %0, %1" : : "a"(val), "Nd"(port));
}
__attribute__((always_inline))
static inline void outl(uint16_t port, uint32_t val) {
    asm volatile("outl %0, %1" : : "a"(val), "Nd"(port));
}
__attribute__((always_inline))
static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}
__attribute__((always_inline))
static inline uint16_t inw(uint16_t port) {
    uint16_t ret;
    asm volatile("inw %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}
__attribute__((always_inline))
static inline uint32_t inl(uint16_t port) {
    uint32_t ret;
    asm volatile("inl %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}
__attribute__((always_inline))
static inline void io_wait() {
    asm volatile("outb %%al, $0x80" : : "a"(0));
}
__attribute__((always_inline))
static inline void cli() {
	asm volatile("cli");
}
__attribute__((always_inline))
static inline void sti() {
	asm volatile("sti");
}
__attribute__((always_inline))
static inline uint64_t rdtsc()
{
	uint64_t ret;
	asm volatile ( "rdtsc" : "=A"(ret) );
	return ret;
}
