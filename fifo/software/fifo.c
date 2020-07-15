#include "fifo.h"
#include "interconnect.h"

int fifo_empty(int base) {
  return MEMGET(base, FIFO_EMPTY);
}

int fifo_full(int base) {
  return MEMGET(base, FIFO_FULL);
}

int fifo_read(int base) {
  return MEMGET(base, FIFO_DATA);
}
void fifo_write(int base, int word) {
    MEMSET(base, FIFO_DATA, word);
}

void fifo_flush(int base) {
  MEMSET(base, FIFO_FLUSH, 0x0);
}

int fifo_level_w(int base) {
  return MEMGET(base, FIFO_LEVEL_W);
}

int fifo_level_r(int base) {
  return MEMGET(base, FIFO_LEVEL_R);
}

unsigned int fifo_tx_samples2full(int base, int depth) {
  return ( depth - fifo_level_w(base));
}
