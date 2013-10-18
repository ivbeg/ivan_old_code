Unit IvKbd;



InterFace
 Uses IvSystem;

Var
 Cbreak_Proc: Procedure;
 Cbreak_Check: Boolean;


Function  GetKey:word;
Procedure FlushKbdBuff;
Function  KeyPresent:boolean;
Procedure WriteKey(Key:Word;Var Ok:boolean);
Procedure SetRate_Delay(Rate,Delay:byte);
Procedure WaitForKey(Key:Word);

Implementation

{$L IvKbd.OBJ}

Function  GetKey:word;External;
Procedure FlushKbdBuff;External;
Function  KeyPresent:boolean;External;
Procedure WriteKey(Key:word;Var Ok:boolean);External;
Procedure SetRate_Delay(Rate,Delay:byte);External;
Procedure WaitForKey(Key:word);External;


begin
 Cbreak_Proc:=DoNone;
 Cbreak_Check:=false;
end.



