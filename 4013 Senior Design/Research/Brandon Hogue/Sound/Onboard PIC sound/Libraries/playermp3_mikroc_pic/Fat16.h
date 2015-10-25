// Fat16.h
//
struct Fat16DirItem
{
  char LongFileName[256];
  bool LongFileNamePresent;
  char ShortFileName[13];
  char FileAttr;
  unsigned long FileSize;
  unsigned int FirstCluster;
};
extern struct Fat16DirItem dirItem;

bool Fat16_Init();
bool Fat16_FindFirst();
bool Fat16_FindNext();
bool Fat16_ChangeDir(char* strDir);
unsigned long Fat16_Assign(char* strFile);
bool Fat16_Read(unsigned char * buff);