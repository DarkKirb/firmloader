#pragma once
#include <stdint.h>
int initDisk();
void readSector(uint16_t tgt_seg, uint16_t tgt_off, uint64_t LBA, uint16_t size);
