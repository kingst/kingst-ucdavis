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
  // assume that we already read the inodeTable in from disk
  inode_t inode = inodeTable[inodeNum];

  // index looks up the position of the block from the file's perspective
  int index = pos / UFS_BLOCK_SIZE;
  // offset finds the offset relative from the start of the disk block
  int offset = pos % UFS_BLOCK_SIZE;
  // blockNum finds the disk block number for this section of the file
  // KEY POINT: inode.direct gives us flexibility to store the bytes for the
  //   file in whatever disk blocks we want
  int blockNum = inode.direct[index];

  // WARNING: let's assume that size does not cross block boundaries to simplify
  //          our implementation

  // why do we need a local variable for block? Why not just use buffer directly?
  char block[UFS_BLOCK_SIZE];
  readDiskBlock(blockNum, block);
  memcpy(buffer, block + offset, size)

  return size;
}
