extern "C"
{
  extern  WORD              PrefixSeg;
  extern  BYTE              FileOpenMod;
  extern  TFunctionResult   DosResult;

  extern  BYTE              DosReadChar(BOOLEAN Echo);
  extern  BYTE              DosReadAuxChar();
  extern  void far          DosWriteChar(BYTE OutChar);
  extern  void far          DosWriteAuxChar(BYTE OutChar);
  extern  void far          DosWritePrnChar(BYTE OutChar);
  extern  BOOLEAN           GetStdinStatus();
  extern  void far          DosBufferedInput(sDosBuffInputRec* Buffer);
  extern  void far          DosWriteString(char* String);


  extern  void far          DiskReset();
  extern  void far          SelectDrive(BYTE Drive);
  extern  BYTE              GetDefaultDrive();
//* extern  void far          GetDefDriveInfo(?? Info);
//* extern  void far          GetDriveInfo(BYTE Drive, ?? Info);
  extern  sDptRec*          GetDefDriveDPT();
  extern  sDptRec*          GetDriveDPT(BYTE Drive);
  extern  void far          SetVerifyFlag(BOOLEAN Flag);
  extern  BOOLEAN           GetVerifyFlag();
  extern  BYTE              GetBootDrive();
//* extern  void far          GetFreeDiskSpace(BYTE Drive, ?? Info );
  extern  void far          ConvertBPBtoDPB(void far* BPB, sDptRec* DPT);
  extern  void far          EnableDrive(BYTE Drive);
  extern  void far          DisableDrive(BYTE Drive);


  extern  void far          SetInterruptVector(BYTE Interrupt, DWORD NewVector);
  extern  DWORD             GetInterruptVector(BYTE Interrupt);
  extern  void far          GetSystemDate(sDosDate* Date);
  extern  void far          SetSystemDate(sDosDate* Date);
  extern  void far          GetSystemTime(sDosTime* Time);
  extern  void far          SetSystemTime(sDosTime* Time);
  extern  void far          SetDiskTransferArea(void far* NewDta);
  extern  void far*         GetDiskTransferArea();
  extern  WORD              GetDosVersion();
  extern  BOOLEAN           GetExtBreakCheck();
  extern  void far          SetExtBreakCheck(BYTE Flag);
  extern  BYTE*             GetIndosFlagPtr();
  extern  BYTE              GetSwitchChar();
  extern  void far          SetSwitchChar(BYTE NewChar);
  extern  sSystemVariables* GetSysvarsPtr();


  extern  void far          StayTSR(BYTE ExitCode);
  extern  BYTE              GetExitCode();
  extern  void far          SetPSP_Address(WORD PSP_Seg);
  extern  WORD              GetPSP_Address();
  extern  void far          CreateChild_PSP(WORD PSP_Seg, WORD PSP_Size);
  extern  WORD              GetCurrentPSP();


  extern  void far          CreateDirectory(char* Directory);
  extern  void far          RemoveDirectory(char* Directory);
  extern  void far          ChangeDirectory(char* Directory);
  extern  void far          GetCurrentDirectory(BYTE Drive, sDirectoryBuffer* Buffer);


  extern  WORD              CreateFile(char* Filename, WORD Attribute);
  extern  WORD              OpenFile(char* Filename);
  extern  void far          CloseFile(WORD Handle);
  extern  WORD              ReadFile(WORD Handle, void far* Buffer, WORD Count);
  extern  WORD              WriteFile(WORD Handle, void far* Buffer, WORD Count);
  extern  void far          DeleteFile(char* Filename);
  extern  void far          SeekFile(WORD Handle, DWORD SeekPos);
  extern  WORD              GetFileAttribute(char* Filename);
  extern  void far          SetFileAttribute(char* Filename, WORD Attribute);
  extern  void far          DuplicateHandle(WORD Handle);
  extern  void far          ForceDuplicateHandle(WORD InHandle, WORD OutHandle);
  extern  void far          RenameFile(char* InFile, char* OutFile);
  extern  WORD              GetFileDate(WORD Handle);
  extern  WORD              GetFileTime(WORD Handle);
  extern  void far          SetFileTimeDate(WORD Handle, WORD Time, WORD Date);
  extern  WORD              CreateNewFile(char* Filename, WORD Attribute);
  extern  WORD              CreateTempFile(char* Filename, WORD Attribute);
  extern  void far          LockFile(WORD Handle, DWORD StartOffset, DWORD LockSize);
  extern  void far          UnlockFile(WORD Handle, DWORD StartOffset, DWORD LockSize);
  extern  void far          GetTrueName(char* FilePath, sDirectoryBuffer* Buffer);
  extern  void far          SetHandlesCount(WORD Count);
  extern  void far          CommitFile(WORD Handle);
  extern  void far          FflushFile(WORD Handle);


  extern  WORD              AllocateMemory(WORD BlockSize);
  extern  void far          ReleaseMemory(WORD Segm);
  extern  void far          ReallocateMemory(WORD Segm, WORD BlockSize);
  extern  BYTE              GetAllocationStrategy();
  extern  void far          SetAllocationStrategy(BYTE NewState);
  extern  BYTE              GetUMB_LinkState();
  extern  void far          SetUMB_LinkState(BYTE NewState);
  extern  void far*         GetFreeHMA_Addr();
  extern  WORD              HMA_MemAvail();
  extern  void far*         AllocateHMA(WORD BlockSize);


  extern  BYTE              CapitalizeChar(BYTE OutChar);
  extern  void far          CapitalizeBuffer(void far* Buffer, WORD Size);
  extern  void far          CapitalizePChar(char* String);


  extern  WORD              GetEnvCount(WORD Segm);
  extern  char*             EnvPChar(WORD Segm, WORD Index);

};


struct sDosVersion
{
  BYTE  Low;
  BYTE  High;
};

typedef sDosVersion* psDosVersion;

void far DosError()
{
  printf("Error Code: 0%Xh\n", DosResult.Result);
};

WORD               DosVersion;
sSystemVariables*  SysVars;
BYTE*              IndosFlag;

void far Init_Newdos()
{
  DosVersion = GetDosVersion();
  SysVars    = GetSysvarsPtr();
  IndosFlag  = GetIndosFlagPtr();

  DosResult.ErrorProc = &DosError;
};
