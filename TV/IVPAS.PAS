{$L WhatCPU2}
Var
 CPU :Byte;
Function GetCPU:Byte;external;

begin
 CPU:=GetCPU;
 Writeln(CPU);
end.