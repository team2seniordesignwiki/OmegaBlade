// Fat16.c
//
#define true 1
#define false 0

#define bool char

#include "Fat16.h"

// MMC Connections
//
sbit Mmc_Chip_Select at LATD0_bit;
sbit Mmc_Chip_Select_Direction at TRISD0_bit;

// MMC
//

bool bFat16Initialized;
const int LFNameChunkSize = 13;
unsigned char LFNamePositions[LFNameChunkSize] =
  { 1,3,5,7,9,0x0E,0x10,0x12,0x14,0x16,0x18,0x1C, 0x1E};

unsigned long SectorInBuffer;
unsigned char DataBuffer[512];

// For FAT reading
//
unsigned long FirstFatSector;
unsigned long MaxFatEntries;
unsigned long SectorsPerFat;
unsigned int OffsetFatBuffer;

// For directory reading
//
unsigned long FirstDirSector;
unsigned long DirEntriesPerSector;
unsigned long SectorsPerCluster;
unsigned int FirstDirCluster;
unsigned int OffsetDirBuffer;

// For directory searching
//
int DirEntry;
bool bEndDir;

struct Fat16DirItem dirItem;

// For file reading
//
unsigned long FileLength;
unsigned long FilePos;
unsigned int FileClusterPos;
unsigned int FileCluster;

// Fat16 Initialize
//
bool Fat16_Init()
{

  unsigned char error;
  long sectorNum;
  bool bPartition;
  int i;
  int offsetTypePartition;
  unsigned char tmp;
  unsigned long * ptrLong;
  unsigned int * ptrInt;
  long BytesPerSector;
  long ReservedSectors;
  long NumberFats;

  bFat16Initialized = false;

  SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
  Mmc_Init();

  sectorNum = 0;
  error = Mmc_Read_Sector(sectorNum, DataBuffer);
  if ( error == 1 )
    return false;

  if ((DataBuffer[0x1FE] != 0x55) || (DataBuffer[0x1FF] != 0xAA))
    return false;

  if ((DataBuffer[0] != 0xEB) && (DataBuffer[0] != 0xE9))
  {
    bPartition = false;
    i = 0;

    while ((i < 4) && (bPartition==false))
    {
      offsetTypePartition = 0x1C2 + (i * 16);
      tmp = DataBuffer[offsetTypePartition];
      if ((tmp == 4) || (tmp == 6) || (tmp == 0x0E))
        bPartition = true;
      i++;
    }

    if ( bPartition == false )
      return false;

    ptrLong = &DataBuffer[offsetTypePartition+4];
    sectorNum = *ptrLong;

    error = Mmc_Read_Sector(sectorNum, DataBuffer);
    if ( error == 1 )
      return false;

    if ((DataBuffer[0x1FE] != 0x55) || (DataBuffer[0x1FF] != 0xAA))
      return false;

    if ((DataBuffer[0] != 0xEB) && (DataBuffer[0] != 0xE9))
      return false;
  }

  ptrInt = &DataBuffer[0x0B];
  BytesPerSector = *ptrInt;
  SectorsPerCluster = DataBuffer[0x0D];
  ptrInt = &DataBuffer[0x0E];
  ReservedSectors = *ptrInt;
  NumberFats = DataBuffer[0x10];
  ptrInt = &DataBuffer[0x16];
  SectorsPerFat = *ptrInt;

  FirstFatSector = sectorNum + ReservedSectors;
  MaxFatEntries = BytesPerSector * SectorsPerFat / 2;
  FirstDirSector = FirstFatSector + (SectorsPerFat * NumberFats);
  DirEntriesPerSector = BytesPerSector / 32;

  SectorInBuffer = -1;
  FirstDirCluster = 0;

  bFat16Initialized = true;

  return true;

}

// Read Fat Sector and calculate offset
//
bool Fat16_ReadFatSector(unsigned int Entry)
{

  unsigned char error;
  unsigned long DesiredSector;

  if ( Entry >= MaxFatEntries )
    return false;

  DesiredSector = Entry / 256;
  DesiredSector = DesiredSector + FirstFatSector;
  OffsetFatBuffer = (Entry % 256) * 2;

  if ( SectorInBuffer != DesiredSector )
  {
    error = Mmc_Read_Sector(DesiredSector, DataBuffer);
    if ( error == 1 )
      return false;

    SectorInBuffer = DesiredSector;

  }

  return true;

}

// Read dir entry and calculate offset
//
bool Fat16_ReadDirEntry(int Entry)
{

  unsigned char error;
  int clusterIndex;
  long sectorIndex;
  unsigned long DesiredSector;
  unsigned int cluster;
  unsigned int *ptrInt;

  sectorIndex = Entry / DirEntriesPerSector;
  clusterIndex = sectorIndex / SectorsPerCluster;
  cluster = FirstDirCluster;
  while (clusterIndex > 0 )
  {
    clusterIndex--;
    Fat16_ReadFatSector(cluster+1);
    ptrInt = &DataBuffer[OffsetFatBuffer];
    cluster = *ptrInt;
    if ( cluster >= 0xfff8 )
      return false;
    cluster--;
  }
  DesiredSector = cluster * SectorsPerCluster;
  DesiredSector = DesiredSector + sectorIndex % SectorsPerCluster;
  DesiredSector  = DesiredSector + FirstDirSector;
  OffsetDirBuffer = (Entry % DirEntriesPerSector) * 32;

  if ( SectorInBuffer != DesiredSector )
  {

    error = Mmc_Read_Sector(DesiredSector, DataBuffer);
    if ( error == 1 )
      return false;

     SectorInBuffer = DesiredSector;

  }

  return true;

}

// Find current directory entry
//
bool Fat16_FindCurrent()
{
  bool bStatut;
  bool bLongFileNameSeen;
  int iLFN;
  int iSFN;
  char ch;
  int i, j;
  int nbr;
  unsigned long * ptrLong;
  unsigned int * ptrInt;

  iLFN = 0;
  bLongFileNameSeen = false;
  while (bEndDir == false)
  {

    if (DataBuffer[OffsetDirBuffer] == 0x00)
    {
      bEndDir = true;
      return false;
    }

    if (DataBuffer[OffsetDirBuffer] != 0xE5)
    {
      if (DataBuffer[OffsetDirBuffer + 11] == 0x0F)
      {
        if ((DataBuffer[OffsetDirBuffer] & 0x40) > 0 )
        {
          bLongFileNameSeen = true;
        }

        nbr=0;
        for (i=0; i<LFNameChunkSize; i++)
        {
          ch = DataBuffer[OffsetDirBuffer + LFNamePositions[i]];
          if ( ch == 0 )
            break;
          nbr++;
        }

        for (i=iLFN-1; i>=0; i--)
        {
          dirItem.LongFileName[i+nbr] = dirItem.LongFileName[i];
        }
        iLFN += nbr;

        j = 0;
        for (i=0; i<LFNameChunkSize; i++)
        {
          ch = DataBuffer[OffsetDirBuffer + LFNamePositions[i]];
          if ( ch == 0 )
            break;
          dirItem.LongFileName[j++] = ch;
        }

        if ((DataBuffer[OffsetDirBuffer] & 0xBF ) == 1 )
        {
          dirItem.LongFileNamePresent = true;
        }
      }
      else
      {
        for (i=iLFN; i<256; i++)
          dirItem.LongFileName[i] = 0;

        if ( bLongFileNameSeen == false )
        {
          dirItem.LongFileNamePresent = false;
        }

        iSFN = 0;
        for (i = 0; i<8;i++)
          if (DataBuffer[OffsetDirBuffer + i] != ' ' )
            dirItem.ShortFileName[iSFN++] = DataBuffer[OffsetDirBuffer + i];

        if ( DataBuffer[OffsetDirBuffer + 8] != ' ' )
          dirItem.ShortFileName[iSFN++] = '.';
        for (i = 0; i<3; i++)
          if (DataBuffer[OffsetDirBuffer + i + 8] != ' ' )
            dirItem.ShortFileName[iSFN++] = DataBuffer[OffsetDirBuffer + i + 8];

        dirItem.ShortFileName[iSFN] = 0;

        ptrLong = &DataBuffer[OffsetDirBuffer+28];
        dirItem.FileSize = *ptrLong;

        dirItem.FileAttr = DataBuffer[OffsetDirBuffer+11];
        ptrInt = &DataBuffer[OffsetDirBuffer+26];
        dirItem.FirstCluster = *ptrInt;

        if ( bLongFileNameSeen == false )
        {
          for (i=0; i<13; i++)
          {
            dirItem.LongFileName[i] = dirItem.ShortFileName[i];
          }
        }
        return true;
      }
    }

    if ((DataBuffer[OffsetDirBuffer] == 0xE5) ||
        (DataBuffer[OffsetDirBuffer + 11] == 0x0F))
    {
      DirEntry++;
      bStatut= Fat16_ReadDirEntry(DirEntry);
      if ( bStatut = false )
      {
        bEndDir = true;
        return false;
      }
    }
  }
  return true;
}

// Find first directory entry
//
bool Fat16_FindFirst()
{
  bool bStatut;

  if (bFat16Initialized == false)
    return false;

  bEndDir = false;

  DirEntry = 0;
  SectorInBuffer = -1;

  bStatut = Fat16_ReadDirEntry(DirEntry);
  if ( bStatut == false )
  {
    bEndDir = true;
    return false;
  }

  bStatut = Fat16_FindCurrent();

  return bStatut;

}

// Find next directory entry
//
bool Fat16_FindNext()
{
  bool bStatut;

  if (bFat16Initialized == false)
    return false;
  if (bEndDir == true )
    return false;

  DirEntry++;
  bStatut = Fat16_ReadDirEntry(DirEntry);
  if ( bStatut == false )
  {
    bEndDir = true;
    return false;
  }

  bStatut = Fat16_FindCurrent();

  return bStatut;

}

// Change directory ( short file name )
//
bool Fat16_ChangeDir(char* strDir)
{

  bool bStatut;
  int res;

  if (bFat16Initialized == false)
    return false;

  bStatut = Fat16_FindFirst();
  while ( bStatut == true )
  {
    res = strcmp(dirItem.ShortFileName, strDir);
    if ( res == 0 )
    {
      FirstDirCluster = dirItem.FirstCluster;
      if ( FirstDirCluster > 0 )
        FirstDirCluster--;
      return true;
    }
    bStatut = Fat16_FindNext();
  }

  return false;

}

// Assign file for reading ( long file name )
//
unsigned long Fat16_Assign(char* strFic)
{

  bool bStatut;
  int res;

  if (bFat16Initialized == false)
    return 0;

  bStatut = Fat16_FindFirst();
  while ( bStatut == true )
  {
    res = strcmp(dirItem.LongFileName, strFic);
    if ( res == 0 )
    {
      FileLength = dirItem.FileSize;
      FilePos = 0;
      FileClusterPos = 0;
      FileCluster = dirItem.FirstCluster;
      if ( FileCluster > 0 )
        FileCluster--;
      return FileLength;
    }
    bStatut = Fat16_FindNext();
  }

  return 0;

}

// Read file
//
bool Fat16_Read(unsigned char * buff)
{

  unsigned char error;
  unsigned long DesiredSector;
  unsigned int* ptrInt;

  if ( FilePos >= FileLength )
     return false;

  DesiredSector = FileCluster * SectorsPerCluster;
  DesiredSector = DesiredSector + FileClusterPos;
  DesiredSector = DesiredSector + FirstDirSector;

  error = Mmc_Read_Sector(DesiredSector, buff);
  if ( error == 1 )
  {
    FilePos = FileLength;
    return true;
  }

  FilePos+=512;

  FileClusterPos++;
  if ( FileClusterPos >= SectorsPerCluster )
  {
    FileClusterPos=0;
    Fat16_ReadFatSector(FileCluster+1);
    ptrInt = &DataBuffer[OffsetFatBuffer];
    FileCluster = *ptrInt;
    if ( FileCluster >= 0xfff8 )
    {
      FilePos = FileLength;
      return true;
    }
    FileCluster--;
  }

  return true;

}

