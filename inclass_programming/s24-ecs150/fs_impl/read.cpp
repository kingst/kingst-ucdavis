#define DIRECT_PTRS (30)
#define UFS_BLOCK_SIZE (4096)

typedef struct {
   int type;                                                
   int size; // in bytes
   int direct[DIRECT_PTRS];
} inode_t;

void readBlock(int blockNum, void *buffer);
inode_t inodeTable[NUM_INODES];

int read(int inodeNum, void *buffer, int size=1, int pos=5000) {

}
