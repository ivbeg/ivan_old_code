Unit TString;

interface

Uses TSystem;

Type
    TString2      = String[2];
    TString4      = String[4];
    TString8      = String[8];
    TString9      = String[9];


      function   HexNibble(Number : byte) : char;
      { return the hexadecimal representation of the lower nibble. }
      inline($58         {  pop  ax       ; AL = Number }
            /$24/$0F     {  and  al,15    ; mask 4 lower bits }
            /$04/$90     {  add  al,90h   ; this code supposed }
            /$27         {  daa           ; by Time Paterson }
            /$14/$40     {  adc  al,40h   ; }
            /$27);       {  daa           ; AL = Result }


Function LowCase(Ch: Char): Char;
Function HexChar(Ch: Char): Byte;

Function  StrLen(Str: PChar): Word;
Function  StrEnd(Str: PChar): PChar;
Function  StrCopy(Source, Dest: PChar): PChar;
Function  StrMove(Source, Dest: PChar; Count: Word): PChar;
Function  StrPCopy(Source: PString; Dest: PChar): PChar;
Procedure StrPas(Source: PChar; Dest: PString);
Function  StrUpper(Str: PChar): PChar;
Function  StrLower(Str: PChar): PChar;

Function  HexByte(Value: Byte): TString2;
Function  HexWord(Value: Word): TString4;
Function  HexLong(Value: Longint): TString8;
Function  HexPtr(Value: Pointer): TString9;

implementation

{$L Strings.OBJ}

Function  LowCase(Ch: Char): Char; External;
Function  HexChar(Ch: Char): Byte; External;

Function  StrLen(Str: PChar): Word; External;
Function  StrEnd(Str: PChar): PChar; External;
Function  StrCopy(Source, Dest: PChar): PChar; External;
Function  StrMove(Source, Dest: PChar; Count: Word): PChar; External;
Function  StrPCopy(Source: PString; Dest: PChar): PChar; External;
Procedure StrPas(Source: PChar; Dest: PString); External;
Function  StrUpper(Str: PChar): PChar; External;
Function  StrLower(Str: PChar): PChar; External;


Function  HexByte(Value: Byte): TString2;
Begin
   HexByte := HexNibble(Value shr 4) + HexNibble(Value);
End;


Function  HexWord(Value: Word): TString4;
Begin
  HexWord:= HexByte(Hi(Value)) + HexByte(Lo(Value));
End;


Function  HexLong(Value: Longint): TString8;
Var
   SegOfs: TSegOfs absolute Value;
Begin
  HexLong:= HexWord(SegOfs.S) + HexWord(SegOfs.O);
End;


Function  HexPtr(Value: Pointer): TString9;
Var
   SegOfs: TSegOfs absolute Value;
Begin
  HexPtr:= HexWord(SegOfs.S) + ':' + HexWord(SegOfs.O);
End;


Function SearchString(Address: Pointer; Count: Word; S: String): Pointer;
Begin
  SearchString:= SearchPtr(Address, Count, Addr(S[1]), Byte(S[0]));
End;



Begin
End.