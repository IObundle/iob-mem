#include "fifo.h"
#include "interconnect.h"

int fifo_empty(int base) {
  return IO_GET(base, FIFO_EMPTY);
}

int fifo_full(int base) {
  return IO_GET(base, FIFO_FULL);
}

int fifo_read(int base) {
  return IO_GET(base, FIFO_DATA);
}
void fifo_write(int base, int word) {
    IO_SET(base, FIFO_DATA, word);
}

void fifo_flush(int base) {
  IO_SET(base, FIFO_FLUSH, 0x0);
}

int fifo_level_w(int base) {
  return IO_GET(base, FIFO_LEVEL_W);
}

int fifo_level_r(int base) {
  return IO_GET(base, FIFO_LEVEL_R);
}

unsigned int fifo_tx_samples2full(int base, int depth) {
  return ( depth - fifo_level_w(base));
}
