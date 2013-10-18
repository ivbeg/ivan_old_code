Type
 PrgBlock = record
  Name:String;
  Size:LongInt;
  Segm:Word;
  Envir:Word;
  Parent:String;
  FullName:String;
 end;

 SftDescBlock = record
  FileName:String;
  Handles:Word;
  Size:LongInt;
  OwnerName:string;
  Free:Boolean;
 end;

 SftBlock = record
  TotDesc:word;
  Segm,Offs:word;
  Arr:array[1..30] of SftDescBlock;
 end;

 XmsBlock = record
  Handle:word;
  Size:LongInt;
  Lock:word;
 end;

 DevBlock = record
  McbName:string;
  Name:string;
  DevSegm:word;
  DevOffs:word;
  DevAttr:word;
  DevType:Boolean;
  SubUnits:byte;
 end;

 McbBlock = record
  Name:string;
  Size:word;
  Segm:word;
  Typ:string;
  Owner:word;
  Parent:String;
 end;

 DptBlock = record
  Bytes:Word;
  HiSector:byte;
  ShiftCount:byte;
  ResSectors:Word;
  FatCopies:byte;
  RootDirEntry:Word;
  DataFiSect:word;
  FATSectors:word;
  FiDirSector:Word;
  DevDrv:Pointer;
  TotClusters:word;
  Fat16:boolean;
  Access:boolean;
  FreeClusters:word;
 end;

 EmsBlock = record
  Handle:word;
  Pages:word;
 end;

SftArrT = Array[1..3] of SftBlock;
McbArrT = Array[1..60] of McbBlock;
DptArrT = Array[1..25] of DptBlock;
PrgArrT = Array[1..40] of PrgBlock;
DevArrT = Array[1..40] of DevBlock;
EmsArrT = Array[1..100] of EmsBlock;
XmsArrT = Array[1..50] of XmsBlock;