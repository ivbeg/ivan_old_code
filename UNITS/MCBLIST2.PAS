{$M 4096,1000,1000}
{$F+}
{$S-}
{$I-}
Uses IvDos,IvSystem,IvCrt,IvString,IvFiles,IvKbd,IvEms,IvMouse;
Type
 McbOutputBlock = record
                   Address    : McbBlockP;
                   McbType    : string[14];
                   Name       : str8;
                   Parent     : str8;
                  end;
Const
 SystemBlock:array[Boolean] of Str4 = ('Code','Data');
 SysBlock      = 'SysBlock';
 DosSystem     = 'System ';
 IoSys         = 'IO.SYS';
 Enviroment    = 'Enviroment';
 FreeMemory    = 'Free Memory';
 ProgData      = ' Data';
 ProgramType   = 'TSR Program';
 DeviceDriver  = 'Device ';
 DevDrvApp     = 'Dev. Drv. App.';
 DosFcbTable   = 'FCB Table';
 DosBuffers    = 'BUFFERS';
 DosFiles      = 'FILES';
 DosStacks     = 'STACKS';
 Driver        = 'Driver';
 DosEmsStacks  = 'EMS ';
 DosCurrDir    = 'Current Dirs';
 Unknown       = 'Unknown';
 None          = 'None';
 DosData       = 'DOS';


Var FindLast:boolean;
    Data:boolean;
    CurrMcb:McbBlockP;
    SegOfe:SegOfs absolute CurrMcb;
    McbOutPut:McbOutputBlock;
    CurrPchar:PChar;
    Shift:byte;

    FPos:byte;
    SaveHandle:word;

Function  TheWait:boolean;
Var C:boolean;
Function SetBool(B:boolean;B2:boolean):boolean;assembler;
 asm
  mov al,B
  mov ah,B2
  or  al,ah
 end;

 Begin
  C:=KeyPresent;
  C:=SetBool(C,LeftButton);
  C:=SetBool(C,RightButton);
  TheWait:=C;
 end;

 Procedure WriteMcb;

  begin
    With McbOutPut do Begin
                                                  CursorXY(Shift+WindMin.X,GetY);
   WriteStr(HexPtr(Address));                     CursorXY(Shift+WindMin.X+12,GetY);
   WriteStr(Name);                                CursorXY(Shift+WindMin.X+21,GetY);
   WriteStr(HexW(Address^.Owner));                CursorXY(Shift+WindMin.X+29,GetY);
   WriteStr(Digit(LongInt(Address^.Size)*16));    CursorXY(Shift+WindMin.X+38,GetY);
   WriteStr(McbType);                             CursorXY(Shift+WindMin.X+54,GetY);
   WriteStr(Parent);                              EndL;
                      End;
  end;

Procedure SystemDataOutPut;

Procedure WriteDataStart;near;
 Begin
  WriteStr('System Data Start...');EndL;
 end;

Procedure WriteDataEnd;near;
 Begin
  WriteStr('System Data End.');EndL;
 end;

Var DataMcb:McbBlockP;
    DataSegOfs:SegOfs absolute DataMcb;

 Begin
  WriteMcb;
  DataMcb:=CurrMcb;
  WriteDataStart;
  Inc(SegOfe.S);
  FindLast:=False;
  McbOutPut.Parent:=DosData+ProgData;
  Shift:=1;
repeat
  McbOutPut.Address:=CurrMcb;
  ArrChToPchar(CurrMcb^.Name,CurrPchar);
  McbOutPut.Name  :=PcharToStr(CurrPchar);
  McbOutPut.Name  :=DelChars(McbOutPut.Name,0,31);
  McbOutPut.Name  :=DelChars(McbOutPut.Name,128,255);
  if McbOutPut.Name[0] = Char(0) then McbOutPut.Name:=None;
  Case CurrMcb^.McbType of
   'D': McbOutPut.McbType:=DeviceDriver+Driver;
   'I': McbOutPut.McbType:=DosSystem+Driver
   else
    Begin
     McbOutPut.Name:=None;
   Case CurrMcb^.McbType of
   'E': McbOutPut.McbType:=DevDrvApp;
   'X': McbOutPut.McbType:=DosFcbTable;
   'F': McbOutPut.McbType:=DosFiles;
   'S': McbOutPut.McbType:=DosStacks;
   'C': McbOutPut.McbType:=DosEmsStacks + DosStacks;
   'B': McbOutPut.McbType:=DosBuffers;
   'L': McbOutPut.McbType:=DosCurrDir;
   else McbOutPut.McbType:=Unknown;
  end;
  end;
  end;
   WriteMcb;
   SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
   FindLast:=(DataSegOfs.S+DataMcb^.Size+1 = SegOfe.S);
  Until FindLast;
  SegOfe.S:=DataSegOfs.S;
 Shift:=0;
 FindLast:=false;
 WriteDataEnd;
end;


Procedure StandartOutPut;
Var SaveB:byte;
 Begin
   Data:=False;
   SaveB:=Byte(McbOutPut.Name[0]);
   Byte(McbOutPut.Name[0]):=2;
  if CurrMcb^.Owner <> SegOfe.S+1 then
    if (CurrMcb^.Name[1] = 'S') and ((CurrMcb^.Name[2] = 'C') or (CurrMcb^.Name[2] = 'D')) then

    {(McbOutPut.Name = 'SD') or (McbOutPut.Name = 'SC') then}

     Begin
      if McbOutPut.Name = 'SD' then Data:= true;
       McbOutPut.McbType:=DosSystem+SystemBlock[Data];
       McbOutPut.Name   :=SysBlock;
       McbOutPut.Parent :=IoSys;
      if Data then SystemDataOutput;
      end else
      if PspRecP(Ptr(CurrMcb^.Owner,0))^.PrgEnvSeg = SegOfe.S+1 then
       Begin
        ArrChToPchar(McbBlockP(Ptr(CurrMcb^.Owner-1,0))^.Name,CurrPchar);
        McbOutPut.Name  :=PcharToStr(CurrPchar);
        McbOutPut.Name  :=DelChars(McbOutPut.Name,0,31);
        McbOutPut.Name  :=DelChars(McbOutPut.Name,128,255);
        McbOutPut.McbType:=Enviroment;
        McbOutPut.Parent :=None;
       end
      else
       Begin
        ArrChToPchar(McbBlockP(Ptr(CurrMcb^.Owner-1,0))^.Name,CurrPchar);
        McbOutPut.Name  :=PcharToStr(CurrPchar);
        McbOutPut.Name  :=DelChars(McbOutPut.Name,0,31);
        McbOutPut.Name  :=DelChars(McbOutPut.Name,128,255);
        McbOutPut.McbType:=McbOutPut.Name + ProgData;
        McbOutPut.Parent :=None;
       end
       else
       Begin
        Byte(McbOutPut.Name[0]):=SaveB;
        McbOutPut.McbType:=ProgramType;
        ArrChToPChar(McbBlockP(Ptr(PspRecP( Ptr( SegOfe.S+1,0 ))^.PrgOwnerSeg-1,0))^.Name,CurrPchar);
        McbOutPut.Parent :=PcharToStr(CurrPchar);
       end;
      if CurrMcb^.Owner = 0 then
       Begin
        McbOutPut.Name:=None;
        McbOutPut.McbType:=FreeMemory;
       end;
       if Data = False then WriteMcb;
      end;

Procedure MainProc;
 Begin
 Shift:=0;
 FindLast:=False;
 New(CurrPchar);
 CurrMcb:=Ptr(SysVars^.FirstMcbSeg,0);
 repeat
  McbOutPut.Address:=CurrMcb;
  ArrChToPchar(CurrMcb^.Name,CurrPchar);
  McbOutPut.Name  :=PcharToStr(CurrPchar);
  McbOutPut.Name  :=DelChars(McbOutPut.Name,0,31);
  McbOutPut.Name  :=DelChars(McbOutPut.Name,128,255);
  if McbOutPut.Name[0] = Char(0) then McbOutPut.Name:=None;
  StandartOutPut;
  FindLast:=(CurrMcb^.McbType = 'Z');
  SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
  if (CurrMcb^.McbType = 'M') and FindLast then
   Begin
    FindLast:= false;
    EndL;
    CursorXY(WindMin.X+20,GetY);
    WriteStr('UMB Memory Control Blocks');EndL;
    CursorXY(WindMin.X+20,GetY);
    WriteStr('--- ------ ------- ------');EndL;
   end;

{  FindLast:=(SegOfe.S = IvEms.PageFrame);}
 Until FindLast;
 Dispose(CurrPchar);
end;

Begin
   WaitProc:=TheWait;
   SetCounter:=True;
   WriteStr('Segm:Offs   Name     Owner   Size     Type of Block   Parent ');EndL;
   WriteStr('---------   ----     -----   ----     -------------   ------ ');EndL;
   MainProc;
   SetCounter:=False;
   Counter:=0;
end.
