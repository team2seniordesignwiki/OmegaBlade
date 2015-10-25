// PlayerMp3.c
//
#define true 1
#define false 0

#define bool char

#define BASE 0x1380

#include "Mp3.h"
#include "Fat16.h"
#include "Resource.h"

const NBR_DIR = 3;
const NBR_FIL = 10;

const X_DIR_TEXT = 25;
const X_MIN_DIR_TEXT = 15;
const X_MAX_DIR_TEXT = 60;
const X_FILE_TEXT = 25;
const Y_MIN_FILE_TEXT = 75;
const Y_MAX_FILE_TEXT = 225;
const X_MIN_SB = 288;
const X_MID_SB = 295;
const X_MAX_SB = 302;
const Y_MIN_SB_1 = 20;
const Y_MAX_SB_1 = 34;
const Y_MIN_ASC_2 = 40;
const Y_MAX_ASC_2 = 54;
const Y_MIN_SB_3 = 80;
const Y_MAX_SB_3 = 94;
const Y_MIN_SB_4 = 205;
const Y_MAX_SB_4 = 219;

const X_MIN_PERCENT = 20;
const X_MAX_PERCENT = 300;
const Y_MIN_PERCENT = 170;
const Y_MAX_PERCENT = 174;

const X_VOLUME = 88;
const Y_VOLUME = 155;

const X_SPECTRUM = 214;
const Y_SPECTRUM = 156;

const X_FILE_NAME = 5;
const Y_FILE_NAME = 5;

const X_AUTHOR = 20;
const Y_AUTHOR = 25;

const X_TITLE = 20;
const Y_TITLE = 45;

const X_ALBUM = 20;
const Y_ALBUM = 65;

const X_COMMANDS = 0;
const Y_COMMANDS = 180;

const X_PLAY_MIN = 134;
const X_PLAY_MAX = 183;
const Y_PLAY_MIN = 180;
const Y_PLAY_MAX = 230;

const X_EJECT_MIN = 26;
const X_EJECT_MAX = 36;
const Y_EJECT_MIN = 200;
const Y_EJECT_MAX = 211;

const X_STOP_MIN = 59;
const X_STOP_MAX = 70;
const Y_STOP_MIN = 200;
const Y_STOP_MAX = 211;

const X_PREV_MIN = 86;
const X_PREV_MAX = 134;
const Y_PREV_MIN = 194;
const Y_PREV_MAX = 218;

const X_NEXT_MIN = 181;
const X_NEXT_MAX = 225;
const Y_NEXT_MIN = 194;
const Y_NEXT_MAX = 218;

const X_SELECTION = 242;
const Y_SELECTION = 195;

const X_BOUCLE_MIN = 246;
const X_BOUCLE_MAX = 258;
const Y_BOUCLE_MIN = 200;
const Y_BOUCLE_MAX = 211;

const X_ALEA_MIN = 279;
const X_ALEA_MAX = 291;
const Y_ALEA_MIN = 200;
const Y_ALEA_MAX = 211;

char lstDir[NBR_DIR][13];

enum ACTIONS { NOTHING=0, VOL, EJECT, STOP, PREV, PLAY, NEXT, BOUCLE, ALEA};

char top;

int fileIndex;
int minFileIndex;
int maxFileIndex;

unsigned long i, file_size;
const BUFFER_SIZE = 512;
char  BufferLarge[BUFFER_SIZE];
char  volume;

// TFT Connections
//
char TFT_DataPort at PORTJ;
char TFT_DataPort_Direction at TRISJ;

sbit TFT_RST at LATD3_bit;
sbit TFT_BLED at LATH5_bit;
sbit TFT_RS at LATH6_bit;
sbit TFT_CS at LATG3_bit;
sbit TFT_RD at LATH1_bit;
sbit TFT_WR at LATH2_bit;
sbit TFT_RST_Direction at TRISD3_bit;
sbit TFT_BLED_Direction at TRISH5_bit;
sbit TFT_RS_Direction at TRISH6_bit;
sbit TFT_CS_Direction at TRISG3_bit;
sbit TFT_RD_Direction at TRISH1_bit;
sbit TFT_WR_Direction at TRISH2_bit;

// Touch Panel Connections
//
sbit DriveX_Left at LATA0_bit;
sbit DriveX_Right at LATD7_bit;
sbit DriveY_Up at LATA1_bit;
sbit DriveY_Down at LATD4_bit;
sbit DriveX_Left_Direction at TRISA0_bit;
sbit DriveX_Right_Direction at TRISD7_bit;
sbit DriveY_Up_Direction at TRISA1_bit;
sbit DriveY_Down_Direction at TRISD4_bit;

unsigned int Xcoord, Ycoord;

const TEXT_SIZE = 40;
char tmp[TEXT_SIZE];
char txtTime[10];

bool bPlay;
bool bStop;
char action;
char selection;

void interrupt()
{
  if (TMR0IF_bit)
  {
    top = 1;
    TMR0H = 0xB;
    TMR0L = 0xDC;
    TMR0IF_bit = 0;
  }
}

// Initialize
//
void Init()
{

  PLLEN_bit = 1;
  Delay_ms(150);

  ANCON0 = 0xF0;
  ADSHR_bit  = 1;
  ANCON1  = 0xFF;
  ADSHR_bit  = 0;

  CM1CON  = 0;
  CM2CON  = 0;

  top = 0;
  T0CON.TMR0ON = 1;
  T0CON.T08BIT = 0;
  T0CON.T0CS   = 0;
  T0CON.T0SE   = 0;
  T0CON.PSA    = 0;
  T0CON.T0PS2  = 1;
  T0CON.T0PS1  = 0;
  T0CON.T0PS0  = 0;
  TMR0H = 0xB;
  TMR0L = 0xDC;

  TMR0IF_bit = 0;
  TMR0IE_bit = 1;
  INTCON = 0xA0;

  TRISF7_bit = 0;
  LATF7_bit = 1;

  volume = 50;
  selection = 0;

  ADC_Init();
  TFT_Init(320, 240);
  TP_TFT_Init(320, 240, 0, 1);
  TP_TFT_Set_ADC_Threshold(900);
  TFT_Fill_Screen(CL_BLACK);

  MP3_Init();

}

// Calibrate Touch Panel
//
void Calibrate()
{
  TFT_Fill_Screen(CL_BLACK);
  TFT_Set_Pen(CL_WHITE, 3);
  TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
  TFT_Write_Text("Calibration touchez d'abord", 70, 100);
  TFT_Line(315, 1, 319, 1);
  TFT_Line(310, 10, 319, 1);
  TFT_Line(319, 5, 319, 1);
  TFT_Write_Text("ici", 290, 20);

  TP_TFT_Calibrate_Min();
  Delay_ms(500);

  TFT_Set_Pen(CL_BLACK, 3);
  TFT_Set_Font(TFT_defaultFont, CL_BLACK, FO_HORIZONTAL);
  TFT_Line(315, 1, 319, 1);
  TFT_Line(310, 10, 319, 1);
  TFT_Line(319, 5, 319, 1);
  TFT_Write_Text("ici", 290, 20);

  TFT_Set_Pen(CL_WHITE, 3);
  TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
  TFT_Line(0, 239, 0, 235);
  TFT_Line(0, 239, 5, 239);
  TFT_Line(0, 239, 10, 229);
  TFT_Write_Text("puis ici ", 15, 200);

  TP_TFT_Calibrate_Max();
  Delay_ms(500);

}

bool IsMp3(char* fileName)
{
  int idx;
  
  idx = 0;
  while ((idx < 12) && (dirItem.ShortFileName[idx] != 0))
  {
    idx++;
  }
  
  if ( idx < 4 )
    return false;

  if ((dirItem.ShortFileName[idx-4] == '.' ) &&
      ((dirItem.ShortFileName[idx-3] == 'm') || (dirItem.ShortFileName[idx-3] == 'M' )) &&
      ((dirItem.ShortFileName[idx-2] == 'p') || (dirItem.ShortFileName[idx-2] == 'P' )) &&
      ((dirItem.ShortFileName[idx-1] == '3') || (dirItem.ShortFileName[idx-1] == '3' )))
    return true;
  else
    return false;

}

// Set max
//
void SetMax()
{

  bool bStatus;
  
  maxFileIndex = 0;
  bStatus = Fat16_FindFirst();
  while (bStatus == true )
  {

    if ( IsMp3(dirItem.ShortFileName))
    {
      maxFileIndex++;
    }
    bStatus = Fat16_FindNext();
 }

}

// Display text ( truncated if necessary )
//
void DisplayText(char* texte, int x, int y)
{
  int l;
  strncpy(tmp, texte, TEXT_SIZE-1);

  l = strlen(tmp);
  if ( l > 35 )
  {
    tmp[35] = '.';
    tmp[36] = '.';
    tmp[37] = '.';
    tmp[38] = 0;
  }
  TFT_Write_Text(tmp, x, y);
}

// Select MP3 files
//
bool SelectFile()
{
  bool bStatus;
  int minDirIdx;
  int maxDirIdx;
  int idx;
  int jdx;
  int rmax;
  int fmax;
  char touch;
  bool bEndFilesSeen;
  bool bEndDirSeen;

  minDirIdx = 0;
  maxDirIdx = NBR_DIR;
  minFileIndex = 0;
  maxFileIndex = NBR_FIL;

  TFT_Set_Brush(1, TFT_RGBToColor16bit(78, 87,108), 0, LEFT_TO_RIGHT, CL_BLACK, CL_BLACK);
  TFT_Set_Pen(TFT_RGBToColor16bit(78, 87,108), 1);
  TFT_Rectangle(0, 0, 319, 239);
  TFT_Set_Pen(CL_WHITE, 1);

  // Fat16 Initialize
  //
  bStatus  = Fat16_Init();
  if ( bStatus == false )
    return false;

  fileIndex = -1;
  while (fileIndex == -1)
  {

    TFT_Set_Brush(1, TFT_RGBToColor16bit(78, 87,108), 0, LEFT_TO_RIGHT, CL_NAVY, CL_BLUE);
    TFT_Rectangle_Round_Edges(X_DIR_TEXT-6, X_MIN_DIR_TEXT-3, X_MAX_SB+8, X_MAX_DIR_TEXT+3, 5);
    TFT_Rectangle_Round_Edges(X_FILE_TEXT-6, Y_MIN_FILE_TEXT-3, X_MAX_SB+8, Y_MAX_FILE_TEXT+3, 5);

    TFT_Line(X_MIN_SB, Y_MAX_SB_1, X_MAX_SB, Y_MAX_SB_1);
    TFT_Line(X_MAX_SB, Y_MAX_SB_1, X_MID_SB, Y_MIN_SB_1);
    TFT_Line(X_MID_SB, Y_MIN_SB_1, X_MIN_SB, Y_MAX_SB_1);

    TFT_Line(X_MIN_SB, Y_MIN_ASC_2, X_MAX_SB, Y_MIN_ASC_2);
    TFT_Line(X_MAX_SB, Y_MIN_ASC_2, X_MID_SB, Y_MAX_ASC_2);
    TFT_Line(X_MID_SB, Y_MAX_ASC_2, X_MIN_SB, Y_MIN_ASC_2);

    TFT_Line(X_MIN_SB, Y_MAX_SB_3, X_MAX_SB, Y_MAX_SB_3);
    TFT_Line(X_MAX_SB, Y_MAX_SB_3, X_MID_SB, Y_MIN_SB_3);
    TFT_Line(X_MID_SB, Y_MIN_SB_3, X_MIN_SB, Y_MAX_SB_3);

    TFT_Line(X_MIN_SB, Y_MIN_SB_4, X_MAX_SB, Y_MIN_SB_4);
    TFT_Line(X_MAX_SB, Y_MIN_SB_4, X_MID_SB, Y_MAX_SB_4);
    TFT_Line(X_MID_SB, Y_MAX_SB_4, X_MIN_SB, Y_MIN_SB_4);

    // Read subdirectories
    //
    jdx = 0;
    rmax = 0;
    bEndDirSeen = false;
    bStatus = Fat16_FindFirst();
    while (bStatus == true )
    {
      idx = 0;
      while ((idx < 12) && (dirItem.ShortFileName[idx] != 0))
      {
        idx++;
      }
      if ( dirItem.FileAttr & 0x10 )
      {
        if ((jdx >= minDirIdx ) && ( jdx <maxDirIdx))
        {
          DisplayText(dirItem.LongFileName, X_DIR_TEXT, rmax*15+X_MIN_DIR_TEXT);
          strcpy(lstDir[rmax], dirItem.ShortFileName);
          rmax++;
        }
        jdx++;
        if ( jdx > maxDirIdx )
        {
          bEndDirSeen = true;
          break;
        }
      }
      bStatus = Fat16_FindNext();
    }
    
    // Read MP3 files
    //
    jdx = 0;
    fmax = 0;
    bEndFilesSeen = false;
    bStatus = Fat16_FindFirst();
    while (bStatus == true )
    {
      idx = 0;
      while ((idx < 12) && (dirItem.ShortFileName[idx] != 0))
      {
        idx++;
      }
      if ( IsMp3(dirItem.ShortFileName))
      {
        if ((jdx >= minFileIndex ) && ( jdx < maxFileIndex ))
        {
          DisplayText(dirItem.LongFileName, X_FILE_TEXT, fmax*15+Y_MIN_FILE_TEXT);
          fmax++;
        }
        jdx++;
        if ( jdx > maxFileIndex )
        {
          bEndFilesSeen = true;
          break;
        }
      }
      bStatus = Fat16_FindNext();
    }
    touch = 0;
    while ( touch == 0 )
    {
      touch = TP_TFT_Press_Detect();
      if ( touch == 1 )
      {
        if (TP_TFT_Get_Coordinates(&Xcoord, &Ycoord) == 0)
        {
          if (Xcoord < X_MIN_SB)
          {
            if (( Xcoord >= X_FILE_TEXT ) &&
                ( Ycoord >= Y_MIN_FILE_TEXT ) &&
                ( Ycoord <= Y_MAX_FILE_TEXT ))
            {
              idx = (YCoord-Y_MIN_FILE_TEXT) / 15;
              if ((idx >= 0 ) &&
                  (idx < fmax))
              {
                fileIndex = minFileIndex + idx;
              }
              else
                touch = 0;
            }
            else if (( Xcoord >= X_DIR_TEXT ) &&
                ( Ycoord >= X_MIN_DIR_TEXT ) &&
                ( Ycoord <= X_MAX_DIR_TEXT ))
            {
              idx = (YCoord-X_MIN_DIR_TEXT) / 15;
              if ((idx >= 0 ) &&
                  (idx < rmax))
              {
                Fat16_ChangeDir(lstDir[idx]);
                minDirIdx = 0;
                maxDirIdx = NBR_DIR;
                minFileIndex = 0;
                maxFileIndex = NBR_FIL;
             }
              else
                touch = 0;
            }
            else
              touch = 0;
          }
          else if ((Xcoord >= X_MIN_SB) &&
              (Xcoord <= X_MAX_SB) &&
              (Ycoord >= Y_MIN_ASC_2) &&
              (Ycoord <= Y_MAX_ASC_2))
          {
            if ( bEndDirSeen )
            {
              minDirIdx += NBR_DIR;
              maxDirIdx += NBR_DIR;
            }
            else
              touch = 0;
          }
          else if ((Xcoord >= X_MIN_SB) &&
              (Xcoord <= X_MAX_SB) &&
              (Ycoord >= Y_MIN_SB_1) &&
              (Ycoord <= Y_MAX_SB_1))
          {
            if ( minDirIdx > 0 )
            {
              minDirIdx -= NBR_DIR;
              maxDirIdx -= NBR_DIR;
            }
            else
              touch = 0;
          }
          else if ((Xcoord >= X_MIN_SB) &&
              (Xcoord <= X_MAX_SB) &&
              (Ycoord >= Y_MIN_SB_4) &&
              (Ycoord <= Y_MAX_SB_4))
          {
            if ( bEndFilesSeen )
            {
              minFileIndex += NBR_FIL;
              maxFileIndex += NBR_FIL;
            }
            else
              touch = 0;
          }
          else if ((Xcoord >= X_MIN_SB) &&
              (Xcoord <= X_MAX_SB) &&
              (Ycoord >= Y_MIN_SB_3) &&
              (Ycoord <= Y_MAX_SB_3))
          {
            if ( minFileIndex > 0 )
            {
              minFileIndex -= NBR_FIL;
              maxFileIndex -= NBR_FIL;
            }
            else
              touch = 0;
          }
          else
            touch = 0;
        }
        else
          touch = 0;
      }
    }
  }

  SetMax();

  return false;

}

// Index to filename
//
bool IndexToFileName(char* fileName)
{
  bool bStatus;
  int idx;
  int jdx;

  jdx = 0;
  bStatus = Fat16_FindFirst();
  while (bStatus == true )
  {
    idx = 0;
    while ((idx < 12) && (dirItem.ShortFileName[idx] != 0))
    {
      idx++;
    }
    if ( IsMp3(dirItem.ShortFileName))
    {
      if (jdx == fileIndex)
      {
        strcpy(fileName, dirItem.LongFileName);
        return true;
      }
      jdx++;
    }
    bStatus = Fat16_FindNext();
 }

}
// Display Volmume
//
void DisplayVolume()
{
  unsigned long nPixels;

  nPixels = X_VOLUME + (100-volume);

  TFT_Set_Brush(1, TFT_RGBToColor16bit(78, 87,108), 0, LEFT_TO_RIGHT, CL_BLACK, CL_BLACK);
  TFT_Set_Pen(TFT_RGBToColor16bit(78, 87,108), 1);
  TFT_Rectangle(X_VOLUME-5, Y_VOLUME-5, X_VOLUME+105, Y_VOLUME+5);

  TFT_Set_Pen(CL_SILVER, 1);
  TFT_H_Line(X_VOLUME, X_VOLUME+100, Y_VOLUME-1);
  TFT_H_Line(X_VOLUME, X_VOLUME+100, Y_VOLUME);
  TFT_H_Line(X_VOLUME, X_VOLUME+100, Y_VOLUME+1);

  TFT_Set_Pen(TFT_RGBToColor16bit(132,197,255), 1);
  TFT_H_Line(X_VOLUME, nPixels, Y_VOLUME-1);
  TFT_Set_Pen(TFT_RGBToColor16bit(15,65,205), 1);
  TFT_H_Line(X_VOLUME, nPixels, Y_VOLUME);
  TFT_Set_Pen(TFT_RGBToColor16bit(110,150,255), 1);
  TFT_H_Line(X_VOLUME, nPixels, Y_VOLUME+1);

  TFT_Set_Brush(1, CL_BLUE, 1, TOP_TO_BOTTOM, TFT_RGBToColor16bit(127,138,211), TFT_RGBToColor16bit(86,216,255));
  TFT_Set_Pen(CL_BLACK, 1);
  TFT_Circle(nPixels, Y_VOLUME, 5);

}

// Display Selection
//
void DisplaySelection()
{

  if ( selection == 0 )
    TFT_Image(X_SELECTION, Y_SELECTION, MP3_Nothing, 1);
  else if ( selection == 1 )
    TFT_Image(X_SELECTION, Y_SELECTION, MP3_Boucle, 1);
  else
    TFT_Image(X_SELECTION, Y_SELECTION, MP3_Alea, 1);

}
// Display MP3 Screen
//
void DisplayMP3Screen()
{

  TFT_Set_Font(Tahoma12x15, CL_WHITE, FO_HORIZONTAL);

  TFT_Set_Brush(1, TFT_RGBToColor16bit(78, 87,108), 0, LEFT_TO_RIGHT, CL_BLACK, CL_BLACK);
  TFT_Set_Pen(TFT_RGBToColor16bit(78, 87,108), 1);
  TFT_Rectangle(0, 0, 319, 239);

  TFT_Set_Brush(1, CL_SILVER, 0, LEFT_TO_RIGHT, CL_BLACK, CL_BLACK);
  TFT_Set_Pen(CL_BLACK, 1);
  TFT_Rectangle(X_MIN_PERCENT, Y_MIN_PERCENT, X_MAX_PERCENT, Y_MAX_PERCENT);

  txtTime[0] = 0;

  TFT_Image(X_COMMANDS, Y_COMMANDS, MP3_Commands, 1);
  if ( bPlay )
    TFT_Image(X_PLAY_MIN, Y_PLAY_MIN, MP3_Pause, 1);
  else
    TFT_Image(X_PLAY_MIN, Y_PLAY_MIN, MP3_Play, 1);

  TFT_Image(X_VOLUME-25, Y_VOLUME-6, MP3_Sound, 1);
  DisplayVolume();
  DisplaySelection();

}

// Display file name
//
void DisplayFileName(char* fileName)
{

  TFT_Set_Brush(1, TFT_RGBToColor16bit(78, 87,108), 0, LEFT_TO_RIGHT, CL_BLACK, CL_BLACK);
  TFT_Set_Pen(TFT_RGBToColor16bit(78, 87,108), 1);
  TFT_Rectangle(0, Y_FILE_NAME, 320, Y_ALBUM+16);

  DisplayText(fileName, X_FILE_NAME, Y_FILE_NAME);

}

// Display elapsed time
//
void DisplayElapsedTime()
{
  unsigned int seconds;
  unsigned char minute;
  unsigned char second;

  if ( bStop )
    seconds = 0;
  else
    MP3_Read_Time(&seconds);

  TFT_Set_Font(Tahoma12x15, TFT_RGBToColor16bit(78, 87,108), FO_HORIZONTAL);
  TFT_Write_Text(&txtTime[1], 270, X_FILE_NAME);

  minute = seconds / 60;
  second = seconds % 60;
  ByteToStr(minute, &txtTime);
  ByteToStr(second, &txtTime[3]);
  txtTime[3] = ':';
  if ( txtTime[1] == ' ' )
    txtTime[1] = '0';
  if ( txtTime[4] == ' ' )
    txtTime[4] = '0';

  TFT_Set_Font(Tahoma12x15, CL_WHITE, FO_HORIZONTAL);
  TFT_Write_Text(&txtTime[1], 270, X_FILE_NAME);

}

// Display percentage
//
void DisplayPercentage(unsigned long idx, unsigned long max)
{
  unsigned long nPixels;

  nPixels = X_MIN_PERCENT + 1 + ((X_MAX_PERCENT-X_MIN_PERCENT-2) * idx / max);

  if ( idx == 0 )
  {
    TFT_Set_Brush(1, CL_SILVER, 0, LEFT_TO_RIGHT, CL_BLACK, CL_BLACK);
    TFT_Set_Pen(CL_BLACK, 1);
    TFT_Rectangle(X_MIN_PERCENT, Y_MIN_PERCENT, X_MAX_PERCENT, Y_MAX_PERCENT);
  }
  TFT_Set_Pen(TFT_RGBToColor16bit(132,197,255), 1);
  TFT_H_Line(X_MIN_PERCENT+1, nPixels, Y_MIN_PERCENT+1);
  TFT_Set_Pen(TFT_RGBToColor16bit(15,65,205), 1);
  TFT_H_Line(X_MIN_PERCENT+1, nPixels, Y_MIN_PERCENT+2);
  TFT_Set_Pen(TFT_RGBToColor16bit(110,150,255), 1);
  TFT_H_Line(X_MIN_PERCENT+1, nPixels, Y_MIN_PERCENT+3);

}

// Test commands
//
bool TestCommands()
{

  if ( TP_TFT_Press_Detect() == 1 )
  {
   if (TP_TFT_Get_Coordinates(&Xcoord, &Ycoord) == 0)
    {
      action = NOTHING;
      if ((Xcoord >= X_EJECT_MIN) &&
          (Xcoord <= X_EJECT_MAX) &&
          (Ycoord >= Y_EJECT_MIN) &&
          (Ycoord <= Y_EJECT_MAX))
      {
        action = EJECT;
      }
      else if ((Xcoord >= X_PLAY_MIN) &&
               (Xcoord <= X_PLAY_MAX) &&
               (Ycoord >= Y_PLAY_MIN) &&
               (Ycoord <= Y_PLAY_MAX))
      {
        action = PLAY;
      }
      else if ((Xcoord >= X_STOP_MIN) &&
               (Xcoord <= X_STOP_MAX) &&
               (Ycoord >= Y_STOP_MIN) &&
               (Ycoord <= Y_STOP_MAX))
      {
        action = STOP;
      }
      else if ((Xcoord >= X_VOLUME) &&
               (Xcoord <= X_VOLUME+100) &&
               (Ycoord >= Y_VOLUME-5) &&
               (Ycoord <= Y_VOLUME+5))
      {
        action = VOL;
      }
      else if ((Xcoord >= X_PREV_MIN) &&
               (Xcoord <= X_PREV_MAX) &&
               (Ycoord >= Y_PREV_MIN) &&
               (Ycoord <= Y_PREV_MAX))
      {
        action = PREV;
      }
      else if ((Xcoord >= X_NEXT_MIN) &&
               (Xcoord <= X_NEXT_MAX) &&
               (Ycoord >= Y_NEXT_MIN) &&
               (Ycoord <= Y_NEXT_MAX))
      {
        action = NEXT;
      }
      else if ((Xcoord >= X_BOUCLE_MIN) &&
               (Xcoord <= X_BOUCLE_MAX) &&
               (Ycoord >= Y_BOUCLE_MIN) &&
               (Ycoord <= Y_BOUCLE_MAX))
      {
        action = BOUCLE;
      }
      else if ((Xcoord >= X_ALEA_MIN) &&
               (Xcoord <= X_ALEA_MAX) &&
               (Ycoord >= Y_ALEA_MIN) &&
               (Ycoord <= Y_ALEA_MAX))
      {
        action = ALEA;
      }
    }
    return false;
  }

  if ( action > NOTHING )
    return true;

  return false;

}

// Read MP3 Tags ( only in first sector )
//
void ReadTags()
{
  int idx;
  int jdx;
  unsigned char lng;

  if (( BufferLarge[0] == 'I' ) &&
      ( BufferLarge[1] == 'D' ) &&
      ( BufferLarge[2] == '3' ))
  {
    idx = 10;
  }
  while ( idx < 501 )
  {
    if ((BufferLarge[idx] == 'T' ) &&
        (BufferLarge[idx+1] == 'P' ) &&
        (BufferLarge[idx+2] == 'E' ) &&
        ((BufferLarge[idx+3] == '1' ) || (BufferLarge[idx+3] == '2' )))
    {
      lng = BufferLarge[idx+7]-1;
      idx+=11;
      if (idx+lng < 512 )
      {
        jdx=0;
        while ((lng > 0 ) && ( jdx < TEXT_SIZE-1))
        {
          if ( BufferLarge[idx] == 0 )
            idx++;
          else
            tmp[jdx++] = BufferLarge[idx++];
          lng--;
        }
        tmp[jdx] = 0;
        TFT_Write_Text(tmp, X_AUTHOR, Y_AUTHOR);
      }
      else
        idx+=lng;
    }
    else if ((BufferLarge[idx] == 'T' ) &&
        (BufferLarge[idx+1] == 'I' ) &&
        (BufferLarge[idx+2] == 'T' ) &&
        ((BufferLarge[idx+3] == '1' ) || (BufferLarge[idx+3] == '2' )))
   {
      lng = BufferLarge[idx+7]-1;
      idx+=11;
      if (idx+lng < 512 )
      {
        jdx=0;
        while ((lng > 0 ) && ( jdx < TEXT_SIZE-1))
        {
          if ( BufferLarge[idx] == 0 )
            idx++;
          else
            tmp[jdx++] = BufferLarge[idx++];
          lng--;
        }
        tmp[jdx] = 0;
        TFT_Write_Text(tmp, X_TITLE, Y_TITLE);
      }
      else
        idx+=lng;
    }
    else if ((BufferLarge[idx] == 'T' ) &&
        (BufferLarge[idx+1] == 'A' ) &&
        (BufferLarge[idx+2] == 'L' ) &&
        (BufferLarge[idx+3] == 'B' ))
   {
      lng = BufferLarge[idx+7]-1;
      idx+=11;
      if (idx+lng < 512 )
      {
        jdx=0;
        while ((lng > 0 ) && ( jdx < TEXT_SIZE-1))
        {
          if ( BufferLarge[idx] == 0 )
            idx++;
          else
            tmp[jdx++] = BufferLarge[idx++];
          lng--;
        }
        tmp[jdx] = 0;
        TFT_Write_Text(tmp, X_ALBUM, Y_ALBUM);
      }
      else
        idx+=lng;
    }
    else
    {
      lng = BufferLarge[idx+7]-1;
      idx+=11;
      idx+=lng;
    }
  }
}

// Play MP3 File
//
void PlayFile()
{
  unsigned long FileSize;
  char fileName[256];
  
  unsigned int bands;
  unsigned int spectrum[16];
  unsigned int oldSpectrum[16];
  char str[12];

  bPlay = false;
  bStop = true;

  action = NOTHING;

  fileName[0] = 0;
  FileSize = 0;
  file_size = 0;
  
  DisplayMP3Screen();

  fileIndex = 0;
  selection = 1;

  IndexToFileName(fileName);
  DisplayFileName(fileName);
  SetMax();
  MP3_Reset(volume);
  for (i=0; i<16; i++)
  {
    spectrum[i] = 0;
    oldSpectrum[i] = 0;
  }
  file_size = Fat16_Assign(fileName);
  FileSize = file_size;
  if (file_size > 0 )
  {
    bStop = false;
    bPlay = true;
    DisplayPercentage(0, 100);
    TFT_Image(134, 180, MP3_Pause, 1);
  }
  
  while (1)
  {

    if (file_size > BUFFER_SIZE)
    {
      if ( bPlay && !bStop )
      {
        Fat16_Read(BufferLarge);
        if ( file_size == FileSize )
        {
          ReadTags();
        }
        for (i=0; i<BUFFER_SIZE/32; i++)
        {
          MP3_SDI_Write_32(BufferLarge + i*32);
        }
        file_size -= BUFFER_SIZE;
      }
    }
    else if ( file_size > 0 )
    {
      DisplayPercentage(100, 100);
      Fat16_Read(BufferLarge);
      for (i=0; i<file_size; i++)
      {
        MP3_SDI_Write(BufferLarge[i]);
      }
      DisplayPercentage(0, 100);
      bStop = true;
      bPlay = false;
      DisplayElapsedTime();
      TFT_Image(134, 180, MP3_Play, 1);
      file_size = 0;

      if ( selection == 1 )
      {
        fileIndex++;
        if ( fileIndex >= maxFileIndex )
          fileIndex = 0;

        IndexToFileName(fileName);
        DisplayFileName(fileName);
        MP3_Reset(volume);
        file_size = Fat16_Assign(fileName);
        FileSize = file_size;
        bStop = false;
        bPlay = true;
        DisplayPercentage(0, 100);
        TFT_Image(134, 180, MP3_Pause, 1);
      }
      else if ( selection == 2 )
      {
        fileIndex = fileIndex + TMR0L;
        fileIndex = fileIndex % maxFileIndex;

        IndexToFileName(fileName);
        DisplayFileName(fileName);
        MP3_Reset(volume);
        file_size = Fat16_Assign(fileName);
        FileSize = file_size;
        bStop = false;
        bPlay = true;
        DisplayPercentage(0, 100);
        TFT_Image(134, 180, MP3_Pause, 1);
      }
    }

    if ( top == 1 )
    {
      top = 0;
      if ( file_size > 0 )
      {
        DisplayElapsedTime();
        DisplayPercentage(FileSize-file_size, FileSize);
      }

      MP3_SCI_Write(0x07, 0x1382);
      MP3_SCI_Read(0x06, 1, &bands);
      if ( bands > 16 )
        bands = 16;
      if ( bands > 0 )
      {
        for (i=0; i<bands; i++)
        {
          MP3_SCI_Write(0x07, 0x1384+i);
          MP3_SCI_Read(0x06, 1, &spectrum[i]);
        }
        for (i=0; i<bands; i++)
        {
          spectrum[i]&=0x1f;
          spectrum[i]*=3;
          if ( spectrum[i] > oldSpectrum[i] )
          {
            TFT_Set_Pen(TFT_RGBToColor16bit(15,65,205), 3);
            TFT_V_Line(Y_SPECTRUM-spectrum[i], Y_SPECTRUM-oldSpectrum[i], X_SPECTRUM+6*i);
          }
          else if ( spectrum[i] < oldSpectrum[i] )
          {
            TFT_Set_Pen(TFT_RGBToColor16bit(78, 87,108), 3);
            TFT_V_Line(Y_SPECTRUM-oldSpectrum[i], Y_SPECTRUM-spectrum[i], X_SPECTRUM+6*i);
          }
          oldSpectrum[i] = spectrum[i];
        }
      }
    }

    if ( TestCommands() == true )
    {
      if ( action == EJECT )
      {
        SelectFile();
        IndexToFileName(fileName);
        DisplayMP3Screen();
        DisplayFileName(fileName);
        MP3_Reset(volume);
        file_size = Fat16_Assign(fileName);
        FileSize = file_size;
        bStop = false;
        bPlay = true;
        DisplayPercentage(0, 100);
        TFT_Image(134, 180, MP3_Pause, 1);
      }
      else if ( action == PLAY )
      {
        if ( bStop == true )
        {
          if ( fileName[0] != 0 )
          {
            MP3_Reset(volume);
            file_size = Fat16_Assign(fileName);
            FileSize = file_size;
            bStop = false;
            bPlay = true;
            TFT_Image(134, 180, MP3_Pause, 1);
          }
        }
        else if ( bPlay == true )
        {
          bPlay = false;
          TFT_Image(134, 180, MP3_Play, 1);
        }
        else
        {
          bPlay = true;
          TFT_Image(134, 180, MP3_Pause, 1);
        }
      }
      else if (action == STOP )
      {
        file_size = 0;
        DisplayPercentage(0, 100);
        bStop = true;
        bPlay = false;
        DisplayElapsedTime();
        TFT_Image(134, 180, MP3_Play, 1);
      }
      else if (action == VOL )
      {
        volume = 100-(Xcoord - X_VOLUME);
        MP3_Set_Volume(volume, volume);
        DisplayVolume();
      }
      else if ( action == PREV )
      {
        if ( fileIndex > 0 )
          fileIndex--;
        else
          fileIndex = maxFileIndex-1;

        IndexToFileName(fileName);
        DisplayFileName(fileName);
        MP3_Reset(volume);
        file_size = Fat16_Assign(fileName);
        FileSize = file_size;
        bStop = false;
        bPlay = true;
        DisplayPercentage(0, 100);
        TFT_Image(134, 180, MP3_Pause, 1);
      }
      else if ( action == NEXT )
      {
        fileIndex++;
        if ( fileIndex >= maxFileIndex )
          fileIndex = 0;

        IndexToFileName(fileName);
        DisplayFileName(fileName);
        MP3_Reset(volume);
        file_size = Fat16_Assign(fileName);
        FileSize = file_size;
        bStop = false;
        bPlay = true;
        DisplayPercentage(0, 100);
        TFT_Image(134, 180, MP3_Pause, 1);
      }
      else if ( action == BOUCLE )
      {
        if ( selection == 1 )
          selection = 0;
        else
          selection = 1;
        DisplaySelection();
      }
      else if ( action == ALEA )
      {
        if ( selection == 2 )
          selection = 0;
        else
          selection = 2;
        DisplaySelection();
      }
      action = NOTHING;
    }
    if (!bPlay || bStop )
      Delay_ms(50);
  }
}

void main(void)
{

  Init();
  Delay_100ms();
  Calibrate();

  Fat16_Init();
  PlayFile();

}