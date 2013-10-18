Unit IvMemory;

Interface

Uses IvString,IvSystem,IvMemCtr,IvEms;

         { This Include file have information about type of Memory blocks }

{$I MemInc.inc}

         { This Functions Making Lists of Different Memory Blocks and Put Them into Arrays }
 Function BuildDptList(Var DptArr:DptArrT):Word;
 Function BuildMcbList(Var McbArr:PMcbArrT):Word;
 Function BuildSftList(Var SftArr:PSftArrT):Word;
 Function BuildDeviceList(Var DevArr:DevArrT):Word;
 Function BuildProgramsList(Var PrgArr:PPrgArrT):Word;
 Function BuildEmsList(Var EmsArr:EmsArrT):Word;
 Function BuildXmsList(Var XmsArr:PXmsArrT):Word;
 Function LowMem:word;
 Function ExtMem:word;

Implementation

Function BuildDptList(var DptArr:DptArrT):Word;
{ Building Array of Drive Parameter Tables For All Drives }
var Se,Ofe,Ses,Ofes:word;
    I:byte;
 begin
  DtDpbAdr(Se,Ofe);
  I:=0;
  repeat
   Inc(I);
   Ses:=Se;
   Ofes:=Ofe;
   DptArr[I].Bytes:=MemW[Se:OFe+02];
   DptArr[I].HiSector:=Mem[Se:Ofe+4];
   DptArr[I].ShiftCount:=Mem[Se:Ofe+5];
   DptArr[I].ResSectors:=MemW[Se:Ofe+6];
   DptArr[I].FatCopies:=Mem[Se:Ofe+8];
   DptArr[I].RootDirEntry:=MemW[Se:Ofe+9];
   DptArr[I].DataFiSect:=MemW[Se:Ofe+$0B];
   DptArr[I].FatSectors:=MemW[Se:Ofe+$0F];
   DptArr[I].FiDirSector:=MemW[Se:Ofe+$11];
   DptArr[I].DevDrv:=Ptr(MemW[Se:Ofe+$15],MemW[Se:Ofe+$13]);
   if Mem[Se:Ofe+$18] = 0 then
    DptArr[I].Access:=True
   else
    DptArr[I].Access:=False;
   DptArr[I].TotClusters:=MemW[Se:Ofe+$0D]+1;
   if MemW[Se:OFe+$0D] > $0FF6 then
    DptArr[I].Fat16:=True
   else
    DptArr[I].Fat16:=False;
   DptArr[I].FreeClusters:=Mem[Se:Ofe+$1F];
   Se:=MemW[Ses:Ofes+$1B];
   Ofe:=MemW[Ses:Ofes+$19];
  Until Ofe = $FFFF;
  BuildDptList:=I;
 end;

Function BuildEmsList(Var EmsArr:EmsArrT):word;
 { ** Making List of Ems Handles **}
var Se,Ofe:word;
    UsHandle:word;
 begin
  Se:=Seg(EmsArr);
  Ofe:=Ofs(EmsArr);
   asm
    Push   di
    mov    es,Se;
    mov    di,Ofe
    mov    ah,4Dh
    int    67h
    Pop    di
    mov    UsHandle,bx
   end;
 BuildEmsList:=UsHandle;
 end;

Function BuildXmsList(Var XmsArr:PXmsArrT):Word;
 { ** Making List of High Memory Blocks ** }
var Ptr1:Pointer;
    Se,Ofe:word;
    UsHandle:word;
    Axx:word;
    I:word;
 begin
  asm
   mov  ah,43h
   mov  al,10h
   int  2Fh
   mov  Word Ptr [Ptr1+2],es
   mov  Word Ptr [Ptr1],bx
  end;
  UsHandle:= 0;
  Se:=Seg(XmsArr^);
  Ofe:=Ofs(XmsArr^);

  For I:=1 to 65534 do
   begin
    asm
      mov    ah,0Eh;
      mov    dx,I
      call   [Ptr1]
      mov    AXX,ax
    end;
   if Axx > 0 then
   begin
    asm
     Push di
     mov  es,Se
     mov  di,Ofe
     mov  ax,UsHandle
     mov  cl,3
     shl  ax,cl
     add  di,ax
     mov  ax,i
     mov  es:[di],ax
     mov  es:[di+2],dx
     mov  es:[di+6],bh
    end;
    XmsArr^[UsHandle].Size:=XmsArr^[UsHandle].Size*1024;
    Inc(UsHandle)
   end;
BuildXmsList:=UsHandle - 1;
end;
 end;

Function BuildProgramsList(var PrgArr:PPrgArrT):word;
 { Building List of programs that now present in Memory (Only programs!) }
Const
 CmdLineS = 'CMDLINE=';

Var Count:Byte;
    EnvirS,EnvirO,Se:Word;
    P:pchar;
    Ptr1:Pointer;
    Label Rep;
 begin
  Count:=0;
  Se:=DtFirstMcbSeg;
  Repeat
    Inc(Count);
Rep:

   PrgArr^[Count].Size:= McbSize(se);
   PrgArr^[Count].Segm:= Se;
     if McbOwner(Se) = Se+1 then
        begin
         PrgArr^[Count].Name:=McbName(Se);
         PrgArr^[Count].Parent:=McbName(MemW[Se+1:$16]-1);
         EnvirS:=PspEnvSeg(Se+1);
         PrgArr^[Count].Envir:= EnvirS;
         if EnvirS >0 then
           begin
            EnvirO:=0;
            Ptr1:=Ptr(EnvirS,EnvirO);
            P:=IvString.SearchString(Ptr1,McbSize(EnvirS),CmdLineS);
            if P <> nil then
             PrgArr^[Count].FullName:=GetString(Ptr(Seg(P^),Ofs(P^)+Length(CmdLineS)),254)
            else
             PrgArr^[Count].FullName:='Not Found';
           end
          else
           begin
            PrgArr^[Count].FullName:='Enviroment Not Present';
            PrgArr^[Count].Envir:=$FFFF;
           end;
         Se:=Se+McbSize(Se)+1;
        end
       else
        begin
          if McbTipe(Se) = 'Z' then
           begin
            begin
             PrgArr^[Count].Name:='None';
             PrgArr^[Count].Parent:='None';
             PrgArr^[Count].FullNAme:='Free Memory';
             PrgArr^[Count].Envir:=$FFFF;
            end;
           end
           else
        begin
         Se:=Se+McbSize(Se)+1;
         Goto Rep;
        end;
        end;
  Until (McbTipe(Se) = 'Z') or (Count = 40);
 BuildProgramsList:=Count;
 end;

Function BuildSftList(var SftArr:PSftArrT):word;
Const
 AA1 = 'AUX     ';
 AA2 = 'PRN     ';
 AA3 = 'CON     ';
Var Se,Ofe:word;
    I:byte;
    Segs,OFegs,Ofes,Ses:word;
    Count:Word;
 begin
  DtSftAdr(Se,Ofe);
  I:=0;
  repeat
   Inc(I);
   SftArr^[I].TotDesc:=MemW[Se:Ofe+4];
   Segs:=Se;
   Ofegs:=Ofe+6;
   SftArr^[I].Segm:=Se;
   SftArr^[I].Offs:=Ofe;
   for Count:=1 to SftArr^[I].TotDesc do
    begin
      if (MemL[Segs:Ofegs] = 0) and (MemL[Segs:Ofegs+$20] = 0) then
        SftArr^[I].Arr[Count].Free:=True
       else
        SftArr^[I].Arr[Count].Free:=False;
      SftArr^[I].Arr[Count].FileName:=GetString(Ptr(Segs,Ofegs+$20),8)+':'
      +GetString(Ptr(Segs,Ofegs+$28),3);
      SftArr^[I].Arr[Count].Handles:=MemW[Segs:Ofegs];
      SftArr^[I].Arr[Count].Size:=MemW[Segs:Ofegs+$11];
      if (GetString(Ptr(Segs,Ofegs+$20),8) = AA1)
       or (GetString(Ptr(Segs,Ofegs+$20),8) = AA2)
       or (GetString(Ptr(Segs,Ofegs+$20),8) = AA3) then
       begin
        SftArr^[I].Arr[Count].OwnerName:='IO.SYS';
       end
       else
        begin
         SftArr^[I].Arr[Count].OwnerName:=McbName(MemW[Segs:Ofegs+$31]-1);
        end;


      Ofegs:=Ofegs+59;
    end;

   Ses:=Se;
   Ofes:=Ofe;
   Se:=MemW[Ses:Ofes+2];
   Ofe:=MemW[Ses:Ofes];

  Until Ofe = $FFFF;
  BuildSftList:=I;
end;

Function BuildDeviceList(Var DevArr:DevArrT):Word;
 { ** Making List of Device Drivers ** }
Const
 LPT1 = 'LPT1    ';
 LPT2 = 'LPT2    ';
 LPT3 = 'LPT3    ';
 COM1 = 'COM1    ';
 COM2 = 'COM2    ';
 COM3 = 'COM3    ';
 COM4 = 'COM4    ';
 CON  = 'CON     ';
 PRN  = 'PRN     ';
 AUX  = 'AUX     ';
 CLOCK = 'CLOCK$  ';
var Se,Ofe:word;
    Count:byte;
    Typ:byte;
    Ses,Ofes:word;
 begin
  Count:=1;
  DtDevDrvAdr(Se,Ofe);
  repeat
  Ses:=Se;
  Ofes:=Ofe;
  DevArr[Count].DevType:=BitofW(MemW[Se:Ofe+4],1);
  DevArr[Count].DevAttr:=MemW[Se:Ofe+4];
  if not DevArr[Count].DevType then
   begin
    DevArr[Count].Name:=GetString(Ptr(Se,Ofe+$0A),8);
    DevArr[Count].SubUnits:=0;
    DevArr[Count].McbName:=GetString(Ptr(Se-1,Ofe+$8),8);
   end
  else
   begin
    DevArr[Count].Name:=GetString(Ptr(Se,Ofe+$0B),7);
    DevArr[Count].SubUnits:=Mem[Se:Ofe+$0A];
    DevArr[Count].McbName:=' SYSTEM  ';
   end;
  IF (DevArr[Count].Name = LPT1) or (DevArr[Count].Name = LPT2) or (DevArr[Count].Name = LPT3) or
     (DevArr[Count].Name = COM1) or (DevArr[Count].Name = COM2) or (DevArr[Count].Name = COM3) or
     (DevArr[Count].Name = COM4) or (DevArr[Count].Name = CON) or (DevArr[Count].Name = PRN) or
     (DevArr[Count].Name = AUX) or (DevArr[Count].Name = CLOCK) then
      begin
       DevArr[Count].McbName:='Internal';
      end;
   DevArr[Count].DevSegm:=Se;
   DevArr[Count].DevOffs:=Ofe;
  Se:=MemW[Ses:Ofes+$2];
  Ofe:=MemW[Ses:Ofes];
  if Ofe = $FFFF then BuildDeviceList:=Count;
  inc(Count);
  Until Ofe =  $FFFF
 end;

Function BuildMcbList(var McbArr:PMcbArrT):Word;
var Se,Segb:word;
    Count:byte;
    C:byte;
 begin
  Count:= 0;
  Se:=DtFirstMcbSeg;
  repeat
     Inc(Count);
   McbArr^[Count].Owner:=McbOwner(Se);
   McbArr^[Count].Size:=McbSize(Se);
   McbArr^[Count].Segm:=Se;
Case McbTipe(Se) of
 'M': begin
       if McbOwner(Se) <> Se+1 then
        begin
         if (McbName(Se) = 'SC      ') or (McbName(Se) = 'SD      ') then
          begin
           McbArr^[Count].Name:='SysBlock';
           if McbName(Se) = 'SC      ' then
            begin
             McbArr^[Count].Parent:='IO.SYS';
             McbArr^[Count].Typ:='System Code'
            end
           else
            begin
             McbArr^[Count].Parent:='IO.SYS';
             McbArr^[Count].Typ:='System Data';
             Segb:=Se;
             C:=Count;
             Se:=Se+1;
              repeat
              Inc(Count);
               McbArr^[Count].Owner:=McbOwner(Se);
               McbArr^[Count].Size:=McbSize(Se);
               McbArr^[Count].Segm:=Se;
              Case McbTipe(Se) of
                'C': begin
                      McbArr^[Count].Typ:='Dos Ems Buffers';
                      McbArr^[Count].Name:='None    ';
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'B': begin
                       McbArr^[Count].Typ:='Dos Buffers';
                       McbArr^[Count].Name:='None    ';
                       McbArr^[Count].Parent:='IO.SYS';
                     end;
                'S': begin
                      McbArr^[Count].Typ:='Dos Stacks';
                      McbArr^[Count].Name:='None    ';
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'I': begin
                      McbArr^[Count].Typ:='System Driver';
                      McbArr^[Count].Name:=McbName(Se);
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'D': begin
                      McbArr^[Count].Typ:='Device Driver';
                      McbArr^[Count].Name:=McbName(Se);
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'E': begin
                      McbArr^[Count].Typ:='Dev. Driver App.';
                      McbArr^[Count].Name:=McbName(Se);
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'X': begin
                      McbArr^[Count].Typ:='FCB Table';
                      McbArr^[Count].Name:='None    ';
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'L': begin
                      McbArr^[Count].Typ:='Directory List';
                      McbArr^[Count].Name:='None    ';
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                'F': begin
                      McbArr^[Count].Typ:='Dos Files';
                      McbArr^[Count].Name:='None    ';
                      McbArr^[Count].Parent:='IO.SYS';
                     end;
                end;
                Se:=Se+McbSize(Se)+1;
               Until Se = Segb + McbSize(Segb)+1;
                end;
          end
         else
          begin
           McbArr^[Count].Parent:='None';
           McbArr^[Count].Typ:='Enviroment';
           McbArr^[Count].Name:=McbName(McbOwner(Se)-1);
          end;
        end
       else
        begin
         McbArr^[Count].Typ:='Program';
         McbArr^[Count].Name:=McbName(Se);
         McbArr^[Count].Parent:=McbName(MemW[Se+1:$16]-1);
        end;
       if McbOwner(Se) = 0 then
        begin
         McbArr^[Count].Typ:='Free Memory';
         McbArr^[Count].Name:='None    ';
        end;
        end;
 'Z': begin
       if McbOwner(Se) <> Se+1 then
        begin
         if (McbName(Se) = 'SC      ') or (McbName(Se) = 'SD      ') then
          begin
           McbArr^[Count].Parent:='None';
           McbArr^[Count].Typ:='System Code or Data';
           McbArr^[Count].Name:='SysBlock';
          end
         else
          begin
           McbArr^[Count].Typ:='Enviroment';
           McbArr^[Count].Name:=McbName(McbOwner(Se)-1);
          end;
        end
       else
        begin
         McbArr^[Count].Parent:=McbName(MemW[Se+1:$16]);
         McbArr^[Count].Typ:='Program';
         McbArr^[Count].Name:=McbName(Se);
        end;
       if McbOwner(Se) = 0 then
        begin
         McbArr^[Count].Parent:='None';
         McbArr^[Count].Typ:='Free Memory';
         McbArr^[Count].Name:='None    ';
        end;
      end;

 'C': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Dos Ems Buffers';
       McbArr^[Count].Name:='None    ';
      end;
 'B': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Dos Buffers';
       McbArr^[Count].Name:='None    ';
      end;
 'S': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Dos Stacks';
       McbArr^[Count].Name:='None    ';
      end;
 'I': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='System Driver';
       McbArr^[Count].Name:=McbName(Se);
      end;
 'D': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Device Driver';
       McbArr^[Count].Name:=McbName(Se);
      end;
 'E': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Dev. Driver App.';
       McbArr^[Count].Name:=McbName(Se);
      end;
 'X': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='FCB Table';
       McbArr^[Count].Name:='None    ';
      end;
 'L': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Directory List';
       McbArr^[Count].Name:='None    ';
      end;
 'F': begin
       McbArr^[Count].Parent:='IO.SYS';
       McbArr^[Count].Typ:='Dos Files';
       McbArr^[Count].Name:='None    ';
      end
  else Count :=60;
 end;
  SegB:=Se;
  Se:=Se+McbSize(Se)+1;
  Until (McbTipe(SegB) = 'Z') or (Count >= 60);
   BuildMcbList:=Count;
 end;





Function LowMem:word;

var Me:word;
begin
  asm
   int   12h
   mov   Me,ax
  end;
 LowMem:=Me;
end;

Function ExtMem:word;
var Me:word;
 begin
  asm
   mov  ah,88h
   int  15h
   mov  Me,ax
  end;
 ExtMem := Me;
end;



end.

