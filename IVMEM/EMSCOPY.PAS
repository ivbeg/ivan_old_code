{ MARK LEWIS }

PROGRAM EMSCopy;

USES
  IvStream;  {The Object unit is need to access TStream}

VAR
  InFile,
  OutFile   : PStream;       {Pointer to InPut/OutPut Files}
  EMSStream : PStream;       {Pointer to EMS Memory Block}
  InPos     : LongInt;       {Where are we in the Stream}

BEGIN
  Writeln;
  Writeln('                  EMSCopy v1.00');
  Writeln;
  Writeln('{ Mangled together from code in the FIDO PASCAL Echo }');
  Writeln('{ Assembled by Mark Lewis                            }');
  Writeln('{ Some ideas and code taken from examples by         }');
  Writeln('{ DJ Murdoch and Todd Holmes                         }');
  Writeln('{ Released in the Public Domain                      }');
  Writeln;
  If ParamCount < 2 Then
  Begin
    Writeln('Usage: EMSCopy <Source_File> <Destination_File>');
    Halt(1);
  End;

  Infile := New(PBufStream, init(paramstr(1), stOpenRead, 4096));
  If (InFile^.Status <> stOK) Then
  Begin
    Writeln(#7, 'Error! Source File Not Found!');
    InFile^.Reset;
    Dispose(InFile, Done);
    Halt(2);
  End;

  Outfile := New(PBufStream, init(paramstr(2), stCreate, 4096));
  If (OutFile^.Status <> stOK) Then
  Begin
    Writeln(#7,'Error! Destination File Creation Error!');
    OutFile^.Reset;
    Dispose(OutFile, Done);
    Halt(3);
  End;

  EMSStream := New(PEMSStream, Init (16000, InFile^.GetSize));
  If (EMSStream^.Status <> stOK) Then
  Begin
    Writeln(#7, 'Error! EMS Allocation Error!');
    Writeln('At Least One Page of EMS Required :(');
    EMSStream^.Reset;
    Dispose(EMSStream, Done);
    Halt(4);
  End;

  Writeln('InPut File Size : ', InFile^.Getsize : 10, ' Bytes');
  InPos := EMSStream^.GetSize;
  Writeln('InPos: ',InPos);
  Repeat
    Writeln('Filling EMS Buffer...     ');
    EMSStream^.CopyFrom(InFile^, InFile^.GetSize - InPos);
    Writeln('Copy ',InFile^.GetSize - InPos,' bytes from InFile.');
    if (EMSStream^.Status <> stOK) then
      EMSStream^.Reset;

    InPos := InPos + EMSStream^.GetSize;
    Write(EMSStream^.GetSize : 10, ' Bytes   ');
    EMSStream^.Seek(0);
    Writeln('Writing DOS File... ');
    OutFile^.CopyFrom(EMSStream^, EMSStream^.GetSize);
    Writeln(OutFile^.Getsize : 10, ' Bytes');
    If (InFile^.Status <> stOK) Then
      InFile^.Reset;
    If (OutFile^.GetSize < InFile^.GetSize) Then
    Begin
      EMSStream^.Seek(0);
      EMSStream^.Truncate;
      InFile^.Seek(InPos);
    End;
  Until (OutFile^.GetSize = InFile^.GetSize);
  Writeln('Done!');
  DISPOSE(InFile, Done);
  DISPOSE(OutFile, Done);
  DISPOSE(EMSStream, Done);
END.
