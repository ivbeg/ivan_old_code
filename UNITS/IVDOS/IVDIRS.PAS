Unit IvDirs;

interface

Uses IvDos,IvSystem;


Procedure MakeDir(DirName:Pchar);
Procedure ChangeDir(DirName:Pchar);
Procedure RemDir(DirName:Pchar);
Function  CurrentDir(Drive:byte):Pchar;

Implementation

{$L dirs.OBJ}
Procedure MakeDir(DirName:Pchar);external;
Procedure ChangeDir(DirName:Pchar);external;
Procedure RemDir(DirName:Pchar);external;

Function  CurrentDir(Drive:byte):Pchar;
Var Drv:byte;
 Begin
 CurrentDir:=nil;
 if Drive > SysVars^.MaxDrives then
  Err.Error:=12                else
 Begin
  If Drive = 0 then
    Drv:=GetCurrDrv
               else
    Drv:=Drive-1;
  CurrentDir:=Addr(SysVars^.CurrDirAddr^[Drv].Directory);
 end;
end;

end.






