typedef struct {
  int type;
  int size;
  int firstBlockNumber;
} inode_t;

typedef struct {
  unsigned char data[UFS_BLOCK_SIZE - sizeof(int)];
  int nextBlockNumber:
} file_block_t;


int read(indoe_t inode, unsigned char *buffer, int bytesToRead) {

}

//////////////////////////////////////////

void LocalFileSystem::move(int parentInodeNumber, string name, int newParentInodeNumber) {

}

