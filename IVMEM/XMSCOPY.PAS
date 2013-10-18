{ MARK LEWIS }

PROGRAM XMSCopy;

USES
  IvStream;  {The Object unit is need to access TStream}

VAR
  InFile,
  OutFile   : PStream;       {Pointer to InPut/OutPut Files}
  XMSStream : PStream;       {Pointer to XMS Memory Block}
  InPos     : LongInt;       {Where are we in the Stream}

BEGIN
  Writeln;
  Writeln('                  XMSCopy v1.00');
  Writeln;
  Writeln('{ Mangled together from code in the FIDO PASCAL Echo }');
  Writeln('{ Assembled by Mark Lewis                            }');
  Writeln('{ Some ideas and code taken from examples by         }');
  Writeln('{ DJ Murdoch and Todd Holmes                         }');
  Writeln('{ Released in the Public Domain                      }');
  Writeln;
  If ParamCount < 2 Then
  Begin
    Writeln('Usage: XMSCopy <Source_File> <Destination_File>');
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

  XMSStream := New(PXMSStream, Init (16000, InFile^.GetSize));
  If (XMSStream^.Status <> stOK) Then
  Begin
    Writeln(#7, 'Error! XMS Allocation Error!');
    Writeln('At Least One Page of XMS Required :(');
    XMSStream^.Reset;
    Dispose(XMSStream, Done);
    Halt(4);
  End;

  Writeln('InPut File Size : ', InFile^.Getsize : 10, ' Bytes');
  InPos := XMSStream^.GetSize;
  Repeat
    Write('Filling XMS Buffer...     ');
    XMSStream^.CopyFrom(InFile^, InFile^.GetSize - InPos);
    if (XMSStream^.Status <> stOK) then
      XMSStream^.Reset;

    InPos := InPos + XMSStream^.GetSize;
    Write(XMSStream^.GetSize : 10, ' Bytes   ');
    XMSStream^.Seek(0);
    Write('Writing DOS File... ');
    OutFile^.CopyFrom(XMSStream^, XMSStream^.GetSize);
    Writeln(OutFile^.Getsize : 10, ' Bytes');
    If (InFile^.Status <> stOK) Then
      InFile^.Reset;
    If (OutFile^.GetSize < InFile^.GetSize) Then
    Begin
      XMSStream^.Seek(0);
      XMSStream^.Truncate;
      InFile^.Seek(InPos);
    End;
  Until (OutFile^.GetSize = InFile^.GetSize);
  Writeln('Done!');
  DISPOSE(InFile, Done);
  DISPOSE(OutFile, Done);
  DISPOSE(XMSStream, Done);
END.
