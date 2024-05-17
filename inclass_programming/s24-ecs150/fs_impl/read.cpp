#define DIRECT_PTRS (30)
#define UFS_BLOCK_SIZE (4096)

typedef struct {
   int type;                                                
   int size; // in bytes
   int direct[DIRECT_PTRS];
} inode_t;

void readDiskBlock(int blockNum, void *buffer);
inode_t inodeTable[NUM_INODES];

// ignore error checking
int read(int inodeNum, void *buffer, int size=1, int pos=5000) {
  inode_t inode = inodeTable[inodeNum];

  int index = pos / UFS_BLOCK_SIZE;
  int offset = pos % UFS_BLOCK_SIZE;
  
  int blockNum = inode.direct[index];

  // let's assume that size does not cross block boundaries
  char block[UFS_BLOCK_SIZE];
  readDiskBlock(blockNum, block);
  memcpy(buffer, block + offset, size)

  return size;
}
