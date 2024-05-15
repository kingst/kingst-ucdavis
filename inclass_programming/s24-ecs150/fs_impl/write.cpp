#define DIRECT_PTRS (30)
#define UFS_BLOCK_SIZE (4096)

typedef struct {
   int type;                                                
   int size; // in bytes
   int direct[DIRECT_PTRS];
} inode_t;

void readBlock(int blockNum, void *buffer);
void writeBlock(int blockNum, void *buffer);
int allocateDataBlock();
inode_t inodeTable[NUM_INODES];

int write(int inodeNum, void *buffer, int size=1, int pos=3*4096) {

}
