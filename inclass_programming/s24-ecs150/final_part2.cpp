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
  int bytesRead = 0;
  int currentBlock = inode.firstBlockNumber;

  while (currentBlock > 0 && bytesToRead > 0) {
    file_block_t fileBlock;
    disk->readBlock(currentBlock, &fileBlock);
    int size = UFS_BLOCK_SIZE - sizeof(int);

    // if the caller does not want to read the entire file
    if (size > bytesToRead) {
      size = bytesToRead;
    }

    // the caller tries to read more bytes than are available in the file
    if (size > (inode.size - bytesRead)) {
      size = inode.size - bytesRead;
    }
    
    memcpy(buffer + bytesRead, fileBlock.data, size);

    bytesRead += size;
    bytesToRead -= size;
    currentBlock = fileBlock.nextBlockNumber;
  }

  return bytesRead;
}

//////////////////////////////////////////

void LocalFileSystem::move(int parentInodeNumber, string name, int newParentInodeNumber) {

}

