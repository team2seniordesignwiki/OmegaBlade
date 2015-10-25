#line 1 "D:/Projets Mikroe/PlayerMp3/Fat16.c"
#line 1 "d:/projets mikroe/playermp3/fat16.h"


struct Fat16DirItem
{
 char LongFileName[256];
  char  LongFileNamePresent;
 char ShortFileName[13];
 char FileAttr;
 unsigned long FileSize;
 unsigned int FirstCluster;
};
extern struct Fat16DirItem dirItem;

 char  Fat16_Init();
 char  Fat16_FindFirst();
 char  Fat16_FindNext();
 char  Fat16_ChangeDir(char* strDir);
unsigned long Fat16_Assign(char* strFile);
 char  Fat16_Read(unsigned char * buff);
#line 12 "D:/Projets Mikroe/PlayerMp3/Fat16.c"
sbit Mmc_Chip_Select at LATD0_bit;
sbit Mmc_Chip_Select_Direction at TRISD0_bit;




 char  bFat16Initialized;
const int LFNameChunkSize = 13;
unsigned char LFNamePositions[LFNameChunkSize] =
 { 1,3,5,7,9,0x0E,0x10,0x12,0x14,0x16,0x18,0x1C, 0x1E};

unsigned long SectorInBuffer;
unsigned char DataBuffer[512];



unsigned long FirstFatSector;
unsigned long MaxFatEntries;
unsigned long SectorsPerFat;
unsigned int OffsetFatBuffer;



unsigned long FirstDirSector;
unsigned long DirEntriesPerSector;
unsigned long SectorsPerCluster;
unsigned int FirstDirCluster;
unsigned int OffsetDirBuffer;



int DirEntry;
 char  bEndDir;

struct Fat16DirItem dirItem;



unsigned long FileLength;
unsigned long FilePos;
unsigned int FileClusterPos;
unsigned int FileCluster;



 char  Fat16_Init()
{

 unsigned char error;
 long sectorNum;
  char  bPartition;
 int i;
 int offsetTypePartition;
 unsigned char tmp;
 unsigned long * ptrLong;
 unsigned int * ptrInt;
 long BytesPerSector;
 long ReservedSectors;
 long NumberFats;

 bFat16Initialized =  0 ;

 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 Mmc_Init();

 sectorNum = 0;
 error = Mmc_Read_Sector(sectorNum, DataBuffer);
 if ( error == 1 )
 return  0 ;

 if ((DataBuffer[0x1FE] != 0x55) || (DataBuffer[0x1FF] != 0xAA))
 return  0 ;

 if ((DataBuffer[0] != 0xEB) && (DataBuffer[0] != 0xE9))
 {
 bPartition =  0 ;
 i = 0;

 while ((i < 4) && (bPartition== 0 ))
 {
 offsetTypePartition = 0x1C2 + (i * 16);
 tmp = DataBuffer[offsetTypePartition];
 if ((tmp == 4) || (tmp == 6) || (tmp == 0x0E))
 bPartition =  1 ;
 i++;
 }

 if ( bPartition ==  0  )
 return  0 ;

 ptrLong = &DataBuffer[offsetTypePartition+4];
 sectorNum = *ptrLong;

 error = Mmc_Read_Sector(sectorNum, DataBuffer);
 if ( error == 1 )
 return  0 ;

 if ((DataBuffer[0x1FE] != 0x55) || (DataBuffer[0x1FF] != 0xAA))
 return  0 ;

 if ((DataBuffer[0] != 0xEB) && (DataBuffer[0] != 0xE9))
 return  0 ;
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

 bFat16Initialized =  1 ;

 return  1 ;

}



 char  Fat16_ReadFatSector(unsigned int Entry)
{

 unsigned char error;
 unsigned long DesiredSector;

 if ( Entry >= MaxFatEntries )
 return  0 ;

 DesiredSector = Entry / 256;
 DesiredSector = DesiredSector + FirstFatSector;
 OffsetFatBuffer = (Entry % 256) * 2;

 if ( SectorInBuffer != DesiredSector )
 {
 error = Mmc_Read_Sector(DesiredSector, DataBuffer);
 if ( error == 1 )
 return  0 ;

 SectorInBuffer = DesiredSector;

 }

 return  1 ;

}



 char  Fat16_ReadDirEntry(int Entry)
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
 return  0 ;
 cluster--;
 }
 DesiredSector = cluster * SectorsPerCluster;
 DesiredSector = DesiredSector + sectorIndex % SectorsPerCluster;
 DesiredSector = DesiredSector + FirstDirSector;
 OffsetDirBuffer = (Entry % DirEntriesPerSector) * 32;

 if ( SectorInBuffer != DesiredSector )
 {

 error = Mmc_Read_Sector(DesiredSector, DataBuffer);
 if ( error == 1 )
 return  0 ;

 SectorInBuffer = DesiredSector;

 }

 return  1 ;

}



 char  Fat16_FindCurrent()
{
  char  bStatut;
  char  bLongFileNameSeen;
 int iLFN;
 int iSFN;
 char ch;
 int i, j;
 int nbr;
 unsigned long * ptrLong;
 unsigned int * ptrInt;

 iLFN = 0;
 bLongFileNameSeen =  0 ;
 while (bEndDir ==  0 )
 {

 if (DataBuffer[OffsetDirBuffer] == 0x00)
 {
 bEndDir =  1 ;
 return  0 ;
 }

 if (DataBuffer[OffsetDirBuffer] != 0xE5)
 {
 if (DataBuffer[OffsetDirBuffer + 11] == 0x0F)
 {
 if ((DataBuffer[OffsetDirBuffer] & 0x40) > 0 )
 {
 bLongFileNameSeen =  1 ;
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
 dirItem.LongFileNamePresent =  1 ;
 }
 }
 else
 {
 for (i=iLFN; i<256; i++)
 dirItem.LongFileName[i] = 0;

 if ( bLongFileNameSeen ==  0  )
 {
 dirItem.LongFileNamePresent =  0 ;
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

 if ( bLongFileNameSeen ==  0  )
 {
 for (i=0; i<13; i++)
 {
 dirItem.LongFileName[i] = dirItem.ShortFileName[i];
 }
 }
 return  1 ;
 }
 }

 if ((DataBuffer[OffsetDirBuffer] == 0xE5) ||
 (DataBuffer[OffsetDirBuffer + 11] == 0x0F))
 {
 DirEntry++;
 bStatut= Fat16_ReadDirEntry(DirEntry);
 if ( bStatut =  0  )
 {
 bEndDir =  1 ;
 return  0 ;
 }
 }
 }
 return  1 ;
}



 char  Fat16_FindFirst()
{
  char  bStatut;

 if (bFat16Initialized ==  0 )
 return  0 ;

 bEndDir =  0 ;

 DirEntry = 0;
 SectorInBuffer = -1;

 bStatut = Fat16_ReadDirEntry(DirEntry);
 if ( bStatut ==  0  )
 {
 bEndDir =  1 ;
 return  0 ;
 }

 bStatut = Fat16_FindCurrent();

 return bStatut;

}



 char  Fat16_FindNext()
{
  char  bStatut;

 if (bFat16Initialized ==  0 )
 return  0 ;
 if (bEndDir ==  1  )
 return  0 ;

 DirEntry++;
 bStatut = Fat16_ReadDirEntry(DirEntry);
 if ( bStatut ==  0  )
 {
 bEndDir =  1 ;
 return  0 ;
 }

 bStatut = Fat16_FindCurrent();

 return bStatut;

}



 char  Fat16_ChangeDir(char* strDir)
{

  char  bStatut;
 int res;

 if (bFat16Initialized ==  0 )
 return  0 ;

 bStatut = Fat16_FindFirst();
 while ( bStatut ==  1  )
 {
 res = strcmp(dirItem.ShortFileName, strDir);
 if ( res == 0 )
 {
 FirstDirCluster = dirItem.FirstCluster;
 if ( FirstDirCluster > 0 )
 FirstDirCluster--;
 return  1 ;
 }
 bStatut = Fat16_FindNext();
 }

 return  0 ;

}



unsigned long Fat16_Assign(char* strFic)
{

  char  bStatut;
 int res;

 if (bFat16Initialized ==  0 )
 return 0;

 bStatut = Fat16_FindFirst();
 while ( bStatut ==  1  )
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



 char  Fat16_Read(unsigned char * buff)
{

 unsigned char error;
 unsigned long DesiredSector;
 unsigned int* ptrInt;

 if ( FilePos >= FileLength )
 return  0 ;

 DesiredSector = FileCluster * SectorsPerCluster;
 DesiredSector = DesiredSector + FileClusterPos;
 DesiredSector = DesiredSector + FirstDirSector;

 error = Mmc_Read_Sector(DesiredSector, buff);
 if ( error == 1 )
 {
 FilePos = FileLength;
 return  1 ;
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
 return  1 ;
 }
 FileCluster--;
 }

 return  1 ;

}
