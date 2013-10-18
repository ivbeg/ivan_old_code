Uses Misc,Xms;
var AAA:byte;
    S,Z,L,K,F,T,G:Word;
    Ptr1:Pointer;
    KK:boolean;
begin
{ asm
  mov    al,0
  mov    ah,43h
  int    2Fh
  mov    AAA,al
 end;
Case AAA of
  0: Writeln('Himem not Intalled.');
128: begin
     Writeln('High Memory Maneger Installed.');
     asm
      mov    al,10h
      mov    ah,43h
      int    2Fh
      mov    L,es
      mov    K,bx
      mov    word ptr [Ptr1],bx
      mov    word ptr [Ptr1+2],es
      mov    ah,0
      call   [Ptr1]
      mov    S,ax
      mov    Z,bx
      mov    ah,8
      call   [Ptr1]
      mov    F,ax
      mov    T,dx
      mov    ah,7
      call   [Ptr1]
      mov    G,ax
     end;
     Case G of
     0: KK:=False;
     1: KK:=True;
     end;
     Writeln('Line A20 Enabled? ',SayNo(KK));
     Writeln(F);
     Writeln(T);
     Writeln(HexWord(S));
     Writeln(HexWord(Z));
     writeln(HexWord(L),':',HexWord(K));


end;
end;
 For AAA:=1 to 4 do
  begin
   Writeln('');
  end;         }
   Writeln(XmsVersion);
   Writeln(XmsRevision);
   Writeln(XmsAvailSize);




end.
