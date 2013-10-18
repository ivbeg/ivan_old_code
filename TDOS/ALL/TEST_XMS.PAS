Uses TSystem, TXms, TStrings, TKeyb;



const
     cs_Ver      : String[4] = '0.01';

     cw_EmsPageSize = $4000;
     csa_YesNo   : array [Boolean] of String[3] = ('NO','YES');
     csa_OnOff   : array [Boolean] of String[3] = ('OFF','ON');
     cs_Bytes    : String[6] = (' Bytes');
     cs_KBytes   : String[7] = (' KBytes');
     csa_DrvType : array [0..2] of String[16] = ('Unknown',
                                                'Microsoft EMM386',
                                                'Quarterdeck QEMM');
     csa_DmaOperationType :  array [boolean] of String[27] = ('Only one DMA register used.',
                                                             'DMA with alternate register.');

type
    TString5  = String[5];
    TString10 = String[10];


     {** How I don't like functions like this! But I haven't any time... **}
Function DigitToString(Num: System.Longint): TString10;
var
   TempString : TString10;
begin
  Str (Num, TempString);
  DigitToString:= TempString;
end;

Function WordToBCDStr(Value: System.Word): TString8;
begin
  WordToBCDStr:=DigitToString(Hi(Value))+'.'+DigitToString(Lo(Value));
end;

Function ByteToBCDStr(Value: System.byte):TString5;
begin
  ByteToBCDStr:=DigitToString(Value shr 4)+'.'+DigitToString(Value and 4);
end;

procedure ShowXMS_Info;
Begin
  Writeln ('XMS Present .............................. ', csa_YesNo[TXms.XMS_Present]);
  if XMS_Present then
   begin
     Writeln ('HMA Present .............................. ',
               csa_YesNo[TXms.HMA_Present]);
     Writeln ('XMM Driver API ........................... ',
               HexPtr(TXms.XMM_DriverAPI));
     Writeln ('XMS Driver Version ....................... ',
               WordToBCDStr(TXms.XMS_Version));
     Writeln ('XMS Driver Internal Version .............. ',
               WordToBCDStr(TXms.XMS_Revision));
     Writeln ('Line A20 Status .......................... ',
               csa_OnOff[TXms.QueryA20]);
     Writeln ('XMS Total Free Memory .................... ',
               TXms.GetFreeXMS, cs_Kbytes);
     Writeln ('XMS Largest Free Memory Block ............ ',
               TXms.GetMaxFreeXMSBlock, cs_Kbytes);
     Writeln ('UMB Total Free Memory .................... ',
               TXms.UMBMaxAvail, cs_Kbytes);
   end;
End;


procedure ShowQEMM_Info;
Begin
  Writeln('');
End;


procedure ShowEMM386_Info;
Begin
End;


procedure ShowEMS_Info;
Begin
  Writeln;
  Writeln ('--------> Here is EMS Information <--------');
  Writeln ('EMS Present .............................. ', csa_YesNo[TXms.EMS_Present]);
  if EMS_Present then
   begin
     Writeln ('EMM Driver API ........................... ',
               HexPtr(TXms.EMM_DriverAPI));
     Writeln ('EMS Version .............................. ',
               ByteToBCDStr(TXms.EMS_Version));
     Writeln ('Page Frame Segment ....................... ',
               HexWord(TXms.PageFrame));
     Writeln ('EMS Total Memory Size .................... ',
               LongInt (TXms.TotalEmsPages)*16, cs_Kbytes);
     Writeln ('EMS Free Memory Size ..................... ',
               LongInt (TXms.GetFreeEmsPages)*16, cs_Kbytes);
     Writeln ('Number of EMS Handles .................... ',
               TotalEmsHandles);
     Writeln ('Number of Used EMS Handles ............... ',
               GetActiveEmsHandles);
     Writeln ('Raw Pages Number ......................... ',
               TotalRawPages);
     Writeln ('Number of Free Raw Pages ................. ',
               TXms.GetFreeRawPages);
     Writeln ('Size of one Raw Page ..................... ',
               EMS_HardwareInfo.RawPagesSize * 16, cs_Bytes);
     Writeln (csa_DmaOperationType[EMS_HardwareInfo.DMA_OperationType]);
     Writeln ('Number of Alternate Registers Sets is ',
               EMS_HardwareInfo.AltRegsSet);
     Writeln ('Number of Registers Sets Assignable to DMA is ',
               EMS_HardwareInfo.DMA_Regs);
     Writeln ('EMS Memory Manager ....................... ',
               csa_DrvType[EMS_DriverType]);
   end; {EmsPresent = true}
     if EMS_DriverType = manager_type_QEMM then
       ShowQEMM_Info else
     if EMS_DriverType = manager_type_EMM386 then
       ShowEMM386_Info;
End;


procedure WriteHeader;
begin
  Writeln('MemInfo Utility Version ',cs_Ver,', Copyright (C) 1997 Ivan Begtin');
end;

Begin
  WriteHeader;
  ShowXMS_Info;
  repeat until KeyPresent;
  ShowEMS_Info;
End.