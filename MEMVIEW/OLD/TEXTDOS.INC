
Procedure TextDosMemoryInfo;
Const
  Z = ' ';
 begin
  Writeln('':30,'Memory:');
  Writeln(Z,'Conventional =',LowMem, 'kb');
  Writeln(Z,'Free Conventional = ',MaxAvail,' bytes');
  Writeln(Z,'Extended = ',ExtMem, ' kb' );

 end;

Procedure TextDosEmsInfo;
 Const
  Z:Char = #32;
 begin
  Writeln('':30,'Ems Information:');
  Writeln(Z,'Ems Memory Total = ',TotalEmsPages*1024,' bytes');
  Writeln(Z,'Ems Memory Free  = ',AvailEmsPages*1024,' bytes');
  Writeln(Z,'Page Frame       = ',HexW(PageFrame));
  Writeln(Z,'Total  Handles   = ',TotalHandles);
  Writeln(Z,'Active Handles   = ',ActivHAndles);
  Writeln(Z,'Total Raw Pages  = ',TotalRawPages);
  Writeln(Z,'Free  Raw Pages  = ',FreeRawPages);
 end;

Procedure TextDosXmsInfo;
 begin
 end;

Procedure TextDosSystemInfo;
 begin
 end;

Procedure TextDosDptList;
Var DptArr:DptArrT;
    FrSpace,Size:LongInt;
 begin
  CountDpt:=BuildDptList(DptArr);
  For Count:=1 to CountDpt do
  begin
   Size:=DptArr[Count].Bytes;
   Size:=Size*(DptArr[Count].HiSector+1)*DptArr[Count].TotClusters;
   FrSpace:=DptArr[Count].Bytes;
   FrSpace:=FrSpace*(DptArr[Count].HiSector+1)*DptArr[Count].FreeClusters;
   GotoXY(10,WhereY);
   Writeln('Drive  ',Chr(Count+64),':');
    GotoXY(40,WhereY); Writeln('Shift Count = ',DptArr[Count].ShiftCount);
   Write('Bytes per Sector = ',DptArr[Count].Bytes);
    GotoXY(40,WhereY); Writeln('Root Directory Entry = ',DptArr[Count].RootDirEntry);
   Write('Sectors per Cluster = ',DptArr[Count].HiSector+1);
    GotoXY(40,WhereY); Writeln('First Directory Sector = ',DptArr[Count].FiDirSector);
   Write('Total Clusters on Disk = ',DptArr[Count].TotClusters);
    GotoXY(40,WhereY); Writeln('FAT Copies = ',DptArr[Count].FATCopies);
   Write('Free Clusters on Disk = ',DptArr[Count].FreeClusters);
    GotoXY(40,WhereY); Writeln('FAT Sectors = ',DptArr[Count].FATSectors);
   Write('Size = ',Size,' bytes');
    GotoXY(40,WhereY); Writeln('First Data Sector = ',DptArr[Count].DataFiSect);
   Write('Free Space = ',FrSpace,' bytes');
    GotoXY(40,WhereY); Writeln('Access :',SayNo(DptArr[Count].Access));
   Write('Sectors before FAT = ',DptArr[Count].ResSectors);
    GotoXY(40,WhereY); Writeln('FAT16  :',SayNo(DptArr[Count].Fat16));
    ReadKey;
  end;
 end;


Procedure TextDosSftList;
Var SftArr:SftArrT;
    ECount:word;
 begin
  CountSft:=BuildSftList(SftArr);
   For Count:=1 to CountSft do
    begin
    GotoXY(20,WhereY);
     Writeln('System File Table Num:',Count,  ' Total Descriptors :',SftArr[Count].TotDesc);
    GotoXY(20,WhereY);
     Writeln('Address ',HexW(SftArr[Count].Segm),':',HexW(SftArr[Count].Offs));
     Writeln(' Name         Handles   Size    Owner Name');
     Writeln(' ----         -------   ----    ----------');
     ECount:=0;
     Repeat
      Inc(ECount);
      Begin
       Case SftArr[Count].Arr[ECount].Free of
        False: Begin
                Write(' ',SftArr[Count].Arr[ECount].FileName);       GotoXY(15,WhereY);
                Write(SftArr[Count].Arr[ECount].Handles);            GotoXY(25,WhereY);
                Write(SftArr[Count].Arr[ECount].Size);               GotoXY(33,WhereY);
                Writeln(SftArr[Count].Arr[ECount].OwnerName);
               End;
        True:  Begin
                Writeln('Free Descriptors = ',SftArr[Count].TotDesc-ECount);
                ECount:=SftArr[Count].TotDesc;
               End;
       end;
      end;
     Until ECount = SftArr[Count].TotDesc;
      end;
    end;

Procedure TextDosXmsList;
 begin
 if XmsPresent then
  begin
  Writeln('Testing Xms Memory...');
  CountXms:=BuildXmsList;
    Writeln('Block   Handle   Size    Lock');
    Writeln('-----   ------   ----    ----');
  For Count:=0 to CountXms do
   begin
     begin
     Write(Count);                    GotoXY(9,WhereY);
     Write(XmsArr[Count].Handle);     GotoXY(18,WhereY);
     Write(XmsArr[Count].Size);       GotoXY(26,WhereY);
     Writeln(XmsArr[Count].Lock);
   end;
  end;
  end
  else
   begin
    Writeln('High Memory Maneger not Present.');
   end;
 end;


Procedure TextDosDevList;
begin
 CountDev:=BuildDevList;
   Writeln('Segm:Offs   Name     McbName   SubUnits ');
   Writeln('---------   ----     -------   -------- ');
 For Count:=1 to CountDev do
  begin
   Write(HexW(DevArr[Count].DevSegm),':',HexW(DevArr[Count].DevOffs),'  ');
   Writeln(DevArr[Count].Name,'  ',CheckString(DevArr[Count].McbName),'     ',DevArr[Count].SubUnits);

end;
end;

Procedure TextDosEmsList;
var X:longInt;
 begin
 if EmsPresent then
  Begin
  TextDosEmsInfo;
  CountEms:=BuildEmsList;
  Writeln('':30,'Ems Handles Table:');
  Writeln('Handle  Pages   Size      Handle Name');
  Writeln('------  -----   ----      -----------');
  for Count:=1 to CountEms do
   begin
    X:=EmsArr[Count].Pages;
    Write(EmsArr[Count].Handle);         GotoXY(9,WhereY);
    Write(EmsArr[Count].Pages);          GotoXY(17,WhereY);
    Write(X*16384);                            GotoXY(27,WhereY);
    Writeln(CheckString(HandleName(EmsArr[Count].Handle)));
   end;
  end
  else
  Writeln('Ems not present.');
 end;



Procedure TextDosMcbList;
var McbArr:McbArrT;
 begin
  CountMcb:=BuildMcbList(McbArr);
   Writeln('Segm:Offs   Name     Owner   Size     Type of Block ');
   Writeln('---------   ----     -----   ----     ------------- ');
   for Count:=1 to CountMcb do
    begin
     Write(HexW(McbArr[Count].Segm),':',HexW(0));
      GotoXY(13,WhereY);
     Write(McbArr[Count].NAme);
      GotoXY(22,WhereY);
     Write(HexW(McbArr[Count].Owner));
      GotoXY(30,WhereY);
     Write(McbArr[Count].Size*16);
      GotoXY(39,WhereY);
     Writeln(McbArr[Count].Typ);
    end;
 end;

Procedure TextDosGMcbList;
var McbArr:McbArrT;
 begin
  CountMcb:=BuildGlobalMcbList(McbArr);
   Writeln('Segm:Offs   Name     Owner   Size     Type of Block   Parent ');
   Writeln('---------   ----     -----   ----     -------------   ------ ');
   for Count:=1 to CountMcb do
    begin
     Write(HexW(McbArr[Count].Segm),':',HexW(0));
      GotoXY(13,WhereY);
     Write(McbArr[Count].NAme);
      GotoXY(22,WhereY);
     Write(HexW(McbArr[Count].Owner));
      GotoXY(30,WhereY);
     Write(McbArr[Count].Size*16);
      GotoXY(39,WhereY);
     Write(McbArr[Count].Typ);
      GotoXY(55,WhereY);
     Writeln(McbArr[Count].Parent);
      end;
 end;

Procedure TextDosProgramsList;
Var PrgArr:PrgArrT;
 begin
  CountPrg:=BuildProgramsList(PrgArr);
   Writeln('Segm:Offs   Name     Envir   Size     Parent   FullName ');
   Writeln('---------   ----     -----   ----     ------   -------- ');
   For Count:=1 to CountPrg do
    begin
     Write(HexW(PrgArr[Count].Segm),':',HexW(0));
      GotoXY(13,WhereY);
     Write(PrgArr[Count].Name);
      GotoXY(22,WhereY);
     Write(HexW(PrgArr[Count].Envir));
      GotoXY(30,WhereY);
     Write(PrgArr[Count].Size*16);
      GotoXY(39,WhereY);
     Write(PrgArr[Count].Parent);
      GotoXY(48,WhereY);
     Writeln(PrgArr[Count].FullName);
    end;
 end;
