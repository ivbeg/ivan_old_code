unit IvXms;

InterFace
Uses IvSystem;

Type
 XMSHandleType = record
                  Flag    : byte;
                  Lock    : Boolean;
                  Address : pointer;
                  Size    : LongInt;
                 end;
 PXmsTable = ^XmsTable;
 XMSTable = array[1..5000] of XMSHandleType;
 PXMSHandleTable= ^XMSHandleTable;
 XMSHandleTable = record
                   VerFlag    : byte;
                   HandleSize : byte;
                   HandleNum  : word;
                   Table      : PXmsTable;
                  end;


Var
   isXms     : Boolean;
   XmsResult : word;
   XmsError  : byte;
   XMM_Addr  : pointer;

Function  XmsPresent:boolean;
Function  XmsVersion:word;
Function  XmsRevVer :word;
Function  XmsTableAddr:PXMSHandleTable;

Implementation

Function  XmsPresent:boolean;
 Begin
 end;

Function  XmsVersion:word;
 Begin
 end;

Function  XmsRevVer :word;
 Begin
 end;

Function  XmsTableAddr:PXMSHandleTable;assembler;
 asm
  mov  ax,4309h
  int  2Fh
  mov  dx,es
  mov  ax,bx
 end;

end.