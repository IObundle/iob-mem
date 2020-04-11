#ifndef IOB_FIFO_H
#define IOB_FIFO_H

#ifndef MEMSET
#define MEMSET(base, location, value) (*((volatile int*) (base + (sizeof(int)) * location)) = value)
#endif

#ifndef MEMGET
#define MEMGET(base, location)        (*((volatile int*) (base + (sizeof(int)) * location)))
#endif


//memory map
#define FIFO_DATA 0
#define FIFO_EMPTY 1
#define FIFO_FULL 2
#define FIFO_LEVEL_R 3
#define FIFO_LEVEL_W 4
#define FIFO_FLUSH 5

//function protos
int fifo_empty( int base);
int fifo_full( int base);
int fifo_read(int base);
void fifo_write(int base, int word);
void fifo_flush(int base);
int fifo_level_w(int base);
int fifo_level_r(int base);
unsigned int fifo_tx_samples2full(int base, int depth);

#endif
