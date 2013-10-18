{$M 2048,0,0}
Program Loader;

Const
 EndMcb     = 'Z';
 NeedMemory = 550;
 ProgName   = #39'Program.exe'#39;
 Kb         = ' Kb';

Type
PMcbBlock = ^TMcbBlock;
TMcbBlock = record
             McbType      :Char;
             Owner        :word;
             Size         :word;
             Reserv       :array[1..3] of byte;
             Name         :array[1..8] of Char;
            end;
SegOfs    = record
             O,S:Word;
            end;

Var
 FreeMemory:word;


Function LoaderSize:Word;
 Begin
  LoaderSize:=PMcbBlock(Ptr(PrefixSeg-1,0))^.Size div 64;
 End;

Function GetDosMaxMem:Longint;assembler;
 asm
  mov  bx,0FFFFh
  mov  ah,48h
  int  21h          {;Call Dos function 48h (Allocate Dos Memory)}
  mov  ax,bx        {;AX <- BX Now Free Mem}
  mov  bx,16        {;BX = 16}
  mul  bx           {;DX:AX = AX*16}
 end;

Function GetFirstMcbSeg:word;assembler;
  asm
   MOV  AH,52h
   INT  21h
   MOV  AX,ES:[BX-2]
  end;


Procedure ErrorMessage;
 Begin
  Writeln('No Free Memory');
  Halt(0);
 end;

Procedure NotEnough;
 Begin
  Writeln('Not Enough Memory to load ',ProgName);
  Writeln('You must Free ',NeedMemory - FreeMemory,Kb,' Conventional Memory ');
  Halt(0);
 end;

Procedure LoadMessage;
 Begin
  Writeln('Program ',ProgName,' was loaded (maybe?)');
  Halt(0);
 end;


Begin
 FreeMemory:=Word(GetDosMaxMem div 1024);
{ if FreeMemory = $FFFF Then ErrorMessage;}
 {$IFDEF DEBUG}
  Writeln('Debug Version.');
  Writeln('Loader Size in Memory: ',LoaderSize,Kb);
  Writeln('Need Memory for Load : ',NeedMemory,Kb);
  Writeln('Free Memory Available: ',Freememory,Kb);
  Writeln('Dos Max Mem          : ',GetDosMaxMem Div 1024,Kb);
 {$ENDIF}
 if NeedMemory > FreeMemory Then NotEnough
                            else LoadMessage;
end.
