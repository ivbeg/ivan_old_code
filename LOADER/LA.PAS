

Const
    Module1 :  PChar = 'LA.MAP';
    Module2 :  PChar = 'LA.MAP';
    Module3 :  PChar = 'LA.MAP';
    Module4 :  PChar = 'LA.MAP';
    Module5 :  PChar = 'LA.MAP';
    Module6 :  PChar = 'LA.MAP';
    Module7 :  PChar = 'LA.MAP';
    Module8 :  PChar = 'LA.MAP';
    Module9 :  PChar = 'LA.MAP';
    Module10 :  PChar = 'LA.MAP';



{$L Loader.OBJ}
Function _SetRegistrate:Byte;Far;External;
Function _GetRegistratingStatus:Byte;Far;External;


Begin

 Writeln(_SetRegistrate);
{ Writeln(_GetRegistratingStatus);}

end.