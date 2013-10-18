Unit IvFiles;
interface
Uses IvString,IvDos,IvSystem;
Const
 StdAttr = 0;
Var
     OpenMode:byte;
     ReWriteF:boolean;

{** Standart Files Functions ** }
Procedure OpenFile(FileName:Pchar;Var Handle:word);
Procedure CreateFile(FileName:Pchar;Attr:word;Var Handle:word);
Procedure RenameFile(File1:Pchar;File2:Pchar);
{Procedure FindFile
Procedure FindNextFile}
Procedure DeleteFIle(Name:Pchar);
Procedure SetFileAttr(Name:Pchar;Attr:word);
Function  GetFileAttr(Name:Pchar):word;
Procedure CloseFile(Handle:word);
Procedure FFlushFile(Handle:word);
Procedure SeekFile(Handle:word; SeekPos:Longint);
Procedure ReadFile(Handle:word;Var Buffer; Count:word; Var Result:word);
Procedure WriteFile(Handle:word;Var Buffer; Count:word; Var Result:word);
Procedure WriteStrInFile(Handle:word;S:string);
Procedure ReadFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);
Procedure WriteFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);
Procedure SetFileTimeDate(Handle,Time,Date:word);
Function  GetFileDate(Handle:word):word;
Function  GetFileTime(Handle:word):word;
Function  GetFileSize(Handle:word):LongInt;
Procedure SetFileSize(Handle:word; Size:longint);
Function  GetFilePos(Handle:word):LongInt;
Function  EOF(Handle:word):boolean;

{ ** Special Files Functions and Procedures ** }
Procedure SetHandlesCount(Num:word);
Procedure DupHandle(Handle:word; Var NewHandle:word);
Procedure ForceDupHandle(Handle1,Handle2:word);

{ ** Io Control Functions ** }
Function  GetHandleAttr(Handle:word):word;
Procedure SetHandleAttr(Handle:word;Attr:word);
Procedure IoReadBuff(Handle:word;Var Buff;Count:word; Var Result:word);
Procedure IoWriteBuff(Handle:word;Var Buff;Count:word; Var Result:word);
Procedure IoReadBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);
Procedure IoWriteBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);
Function  InPutStatus(Handle:word) :boolean;
Function  OutPutStatus(Handle:word):boolean;
Function  HandleRemote(Handle:word):boolean;


implementation

Procedure WriteStrInFile(Handle:word;S:string);
Var Nw:word;
 Begin
  WriteFilePtr(Handle,Addr(S[1]),Byte(S[0]),Nw);
 end;

Function  EOF(Handle:word):boolean;
 Begin
  EOF:=(GetFileSize(Handle) = GetFilePos(Handle));
 end;

Function  GetFilePos(Handle:word):LongInt;
Var W:word;
 Begin
  W:=Handle;
  if W > SysVars^.FirstSft^.FilesNum+1 then
   GetFilePos:=SysVars^.FirstSft^.NextSft^.Files[W-1-SysVars^.FirstSft^.FilesNum].FilePos
                                            else
   GetFilePos:=SysVars^.FirstSft^.Files[W-1].FilePos;
 end;

Procedure FFlushFile(Handle:word);assembler;
Var Error:byte absolute Err;
 asm
  mov  ah,68h
  mov  bx,Handle
  int  21h
  jc   @1
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Procedure SetHandlesCount(Num:word);assembler;
Var Error:byte absolute Err;
 asm
  mov  ah,67h
  mov  bx,Num
  int  21h
  jc   @1
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Procedure ForceDupHandle(Handle1,Handle2:word);assembler;
Var Error:byte absolute Err;
 asm
  mov  ah,46h
  mov  bx,Handle1
  mov  cx,Handle2
  int  21h
  jc   @1
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Procedure DupHandle(Handle:word; Var NewHandle:word);Assembler;
Var Error:byte absolute Err;
 asm
  mov  ah,45h
  mov  bx,Handle
  int  21h
  jc   @1
  Les  di,NewHandle
  mov  es:[di],ax
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Function  GetFileSize(Handle:word):Longint;
Var W:word;
 Begin
  W:=Handle;
  if W > SysVars^.FirstSft^.FilesNum+1 then
   GetFileSize:=SysVars^.FirstSft^.NextSft^.Files[W-1-SysVars^.FirstSft^.FilesNum].FileSize
                                            else
   GetFileSize:=SysVars^.FirstSft^.Files[W-1].FileSize;
 end;

Procedure DeleteFIle(Name:Pchar);assembler;
Var Error:byte absolute Err;
  asm
   push  ds
   mov   ah,41h
   lds   dx,Name
   int   21h
   jc   @1
   mov  Error,0
   jmp  @2
@1:
   mov  Error,al
@2:
  end;

Procedure ReadFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);
Var Se,Ofe:word;
 Begin
  Se:=Seg(Buffer^);
  Ofe:=Ofs(Buffer^);
  asm
   mov   bx,Handle
   mov   cx,Count
   mov   ax,Se
   mov   ds,ax
   mov   dx,Ofe
   mov   ah,3Fh
   int   21h
   jc    @1
   mov   Se,ax
   jmp   @2
@1:
   mov   Se,0
   mov   Ofe,ax
@2:
  end;
   Result:=Se;
   Err.Error:=Lo(Ofe);
 end;

Procedure WriteFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);
Var Se,Ofe:word;
    Error:byte absolute Err;
 Begin
  Se:=Seg(Buffer^);
  Ofe:=Ofs(Buffer^);
  asm
   push  ds
   mov   bx,Handle
   mov   cx,Count
   mov   ax,Se
   mov   ds,ax
   mov   dx,Ofe
   mov   ah,40h
   int   21h
   jc    @1
   mov   Error,0
   mov   Se,ax
   jmp   @2
@1:
   mov   word ptr Result,0
   mov   Error,al
@2:
   pop   ds
  end;
  Result:=Se;
 end;


Procedure ReadFile(Handle:word;Var Buffer; Count:word; Var Result:word);
Var Se:word;
    Error:byte absolute Err;
 Begin
  asm
   push  ds
   mov   bx,Handle
   mov   cx,Count
   lds   dx,Buffer
   mov   ah,3Fh
   int   21h
   jc    @1
   mov   Se,ax
   mov   Error,0
   jmp   @2
@1:
   mov   word ptr Result,0
   mov   Error,al
@2:
   pop   ds
  end;
   Result:=Se;
 end;

Procedure WriteFile(Handle:word;Var Buffer; Count:word; Var Result:word);
Var Se:word;
    Error:byte absolute Err;
 Begin
  asm
   push  ds
   mov   bx,Handle
   mov   cx,Count
   lds   dx,Buffer
   mov   ah,40h
   int   21h
   jc    @1
   mov   Error,0
   mov   Se,ax
   jmp   @2
@1:
   mov   word ptr Result,0
   mov   Error,al
@2:
   pop   ds
  end;
   Result:=Se;
 end;

Procedure CreateFile(FileName:Pchar;Attr:word;Var Handle:word);
Var W:word;
    K:byte;
 Begin
  K:=$5B-byte(ReWriteF)*$1F;
  asm
   Push ds
   lds  dx,FileName
   mov  ah,K
   mov  cx,Attr
   int  21h
   jc   @1
   mov  W,ax
   mov  K,0
   jmp  @2
@1:
   mov  W,255
   mov  K,al
@2:
   Pop ds
  end;
  Handle:=W;
  Err.Error:=K;
 end;

Procedure OpenFile(FileName:Pchar;Var Handle:word);
Var W:word;
    Error:byte absolute Err;
 Begin
  asm
   push ds
   mov  ah,3Dh
   lds  dx,FileName
   mov  al,OpenMode
   int  21h
   jc   @1
   mov  W,ax
   mov  Err,0
   jmp  @2
 @1:
   mov  W,255
   mov  Error,al
 @2:
   pop  ds
  end;
  Handle:=W;
 end;

Procedure CloseFile(Handle:word);assembler;
Var  Error:byte absolute Err;
  asm
   mov    bx,Handle
   mov    ah,3Eh
   int    21h
   jc     @1
   mov    Error,0
   jmp    @2
@1:
   mov    Error,al
@2:
  end;

Procedure SeekFile(Handle:word; SeekPos:LongInt);assembler;
var SeOfe:SegOfs absolute SeekPos;
    Error:byte absolute Err;
  asm
    Mov   bx,Handle
    mov   cx,SeOfe.[S]
    mov   dx,SeOfe.[O]
    mov   al,0
    mov   ah,42h
    int   21h
    jc    @1
    mov   Error,0
    jmp   @2
@1:
    mov   Error,al
@2:
end;

Procedure RenameFile(File1:Pchar;File2:Pchar);assembler;
Var Error:byte absolute Err;
  asm
   push ds
   push es
   mov  ah,56h
   lds  dx,File1
   les  si,File2
   int  21h
   jc   @1
   mov  Error,0
   jmp  @2
@1:
   mov  Error,al
@2:
   pop  ds
   pop  es
  end;


Function  GetFileAttr(Name:Pchar):word; assembler;
Var Error:byte absolute Err;
 asm
  push ds
  mov  ax,4300h
  lds  dx,Name
  int  21h
  jc   @1
  mov  ax,cx
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
  mov  ax,255
@2:
  pop  ds
 end;


Procedure SetFileAttr(Name:Pchar;Attr:word);assembler;
Var Error:byte absolute Err;
 asm
  push ds
  mov  ax,4301h
  lds  dx,Name
  mov  cx,Attr
  int  21h
  jc   @1
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
  pop  ds
 end;

Procedure SetFileTimeDate(Handle,Time,Date:word);assembler;
Var Error:byte absolute Err;
 asm
  mov  bx,Handle
  mov  cx,Time
  mov  dx,Date
  mov  ax,5701h
  int  21h
  jc   @1
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Function  GetFileDate(Handle:word):word;assembler;
Var Error:byte absolute Err;
 asm
  mov  ax,5700h
  mov  bx,Handle
  int  21h
  jc   @1
  mov  ax,dx
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Function  GetFileTime(Handle:word):word;assembler;
Var Error:byte absolute Err;
 asm
  mov  ax,5700h
  mov  bx,Handle
  int  21h
  jc   @1
  mov  Error,0
  mov  ax,cx
  jmp  @2
@1:
  mov  Error,al
@2:
 end;


Procedure IoReadBuff(Handle:word;Var Buff;Count:word; Var Result:word);assembler;
Var Error:byte absolute Err;
 asm
  push ds
  mov ax,4402h
  mov bx,Handle
  lds dx,Buff
  mov cx,Count
  int 21h
  jc  @1
  Lds di,Result
  mov [Di],ax
  jmp @2
@1:
  mov Error,al
@2:
 end;

Procedure IoWriteBuff(Handle:word;Var Buff;Count:word; Var Result:word);assembler;
Var Error:byte absolute Err;
 asm
  push ds
  mov ax,4402h
  mov bx,Handle
  lds dx,Buff
  mov cx,Count
  int 21h
  jc  @1
  Lds di,Result
  mov [Di],ax
  mov Error,0
  jmp @2
@1:
  mov Error,al
@2:
 end;

Procedure IoReadBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);assembler;
Var Error:byte absolute Err;
 asm
  push ds
  mov ax,4402h
  mov bx,Handle
  les di,Buff
  mov dx,es:[di]
  mov ds,es:[di+2]
  mov cx,Count
  int 21h
  jc  @1
  mov Error,0
  Lds di,Result
  mov [Di],ax
  jmp @2
@1:
  mov Error,al
@2:
 end;

Procedure IoWriteBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);assembler;
Var Error:byte absolute Err;
 asm
  push ds
  mov ax,4402h
  mov bx,Handle
  les di,Buff
  mov dx,es:[di]
  mov ds,es:[di+2]
  mov cx,Count
  int 21h
  jc  @1
  mov Error,0
  Lds di,Result
  mov [Di],ax
  jmp @2
@1:
  mov Error,al
@2:
 end;

Function  GetHandleAttr(Handle:word):word;assembler;
Var Error:byte absolute Err;
  asm
   mov  ax,4400h
   mov  bx,Handle
   int  21h
   jc   @1
   mov  ax,dx
  mov Error,0
   jmp  @2
@1:
   mov  Error,al
   mov  ax,0
@2:
  end;

Procedure SetHandleAttr(Handle:word;Attr:word);assembler;
Var Error:byte absolute Err;
 asm
   mov  ax,4401h
   mov  bx,Handle
   mov  dx,Attr
   int  21h
   jc   @1
  mov Error,0
   jmp  @2
@1:
   mov  Error,al
@2:
 end;

Function  InputStatus(Handle:word):boolean;Assembler;
Var Error:byte absolute Err;
 asm
  mov ax,4406h
  mov bx,Handle
  int 21h
  jc  @2
  cmp al,0
  jne @1
  jmp @3
@1:
  mov al,1
  mov Error,0
  jmp @3
@2:
  mov Error,al
@3:
 end;

Function  OutPutStatus(Handle:word):boolean;assembler;
Var Error:byte absolute Err;
 asm
  mov ax,4407h
  mov bx,Handle
  int 21h
  jc  @2
  cmp al,0
  jne @1
  jmp @3
@1:
  mov al,1
  mov Error,0
  jmp @3
@2:
  mov Error,al
@3:
 end;

Function  HandleRemote(Handle:word):boolean;assembler;
Var Error:byte absolute Err;
 asm
  mov ax,440Ah
  mov bx,Handle
  int 21h
  jc  @2
  and dx,32768
  cmp dx,0
  jne @1
  mov al,0
  mov Error,0
  jmp @3
@1:
  mov al,1
  jmp @3
@2:
  mov Error,al
@3:
 end;
 
Procedure SetFileSize(Handle:word; Size:longint);
 Var W:word;
  Begin
   W:=Handle;
   if W > SysVars^.FirstSft^.FilesNum+1 then
    SysVars^.FirstSft^.NextSft^.Files[W-1-SysVars^.FirstSft^.FilesNum].FileSize:=Size
                                            else
    SysVars^.FirstSft^.Files[W-1].FileSize:=Size;
  end;

Begin
 OpenMode:=2;
 ReWriteF:=true;
end.

