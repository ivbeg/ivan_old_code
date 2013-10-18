{$G+}
Unit IvHma;

Interface
Uses NewDos, TSystem;

Type
 THMASignature = Array[1..3] of Char;
Const
 HMATrueSign : THMASignature = ('H','M','A');
 LastHMABlock = 'Z';
 HMABlockTip  = 'M';
 FreeBlock    =  0;


Type
 PHMABlockID = ^THMABlockID;
 THMABlockID = record
                Sign     : THMASignature;
                Reserv1  : Array[1..5] of Byte;
                Size     : Word;
                BlockTip : Char;
                Owner    : Boolean;
                RealSize : Word;
                Reserv2  : Word;
               end;
Var
  HMAResult   : byte;
  FirstHMAPtr : Pointer;

Procedure   InitIvHMA;
Function    AllocateHMA(Size:Word):Pointer;
Procedure   ReleaseHMA(Address:Pointer);
Procedure   ReSizeHMA(Address:Pointer;Size:Word);
Function    GetMaxFreeHMA:Word;
Function    GetAllFreeHMA:Word;
Procedure   DoneIvHMA;

Implementation

Procedure InitIvHMA;
 Begin
  FirstHMAPtr:=Newdos.GetFreeHMAddr;
  With PHMABlockID(FirstHMAPtr)^ DO
   Begin
    Size    := HMAMemAvail;
    Sign    := HMATrueSign;
    BlockTip:= LastHMABlock;
    Owner   := False;
    RealSize:= Size;
   end;
 end;
{$L IVHMA.OBJ}
Function    AllocateHMA(Size:Word):Pointer;External;
Procedure   ReleaseHMA(Address:Pointer);External;
Procedure   ReSizeHMA(Address:Pointer;Size:Word);External;
Function    GetMaxFreeHMA:Word;External;
Function    GetAllFreeHMA:Word;External;

Procedure   DoneIvHMA;
 Begin
  FillByte(Newdos.GetFreeHMAddr,HMAMemAvail,0);
 end;

Begin
end.