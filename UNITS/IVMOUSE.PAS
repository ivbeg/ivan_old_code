{$G+}
Unit IvMouse;

InterFace
Uses IvSystem;

Var
 MousePresent : Boolean;
 MouseType    : Word;
 MouseVersion : Word;

procedure InitMouse;
procedure ShowMouse;
procedure HideMouse;
procedure MouseXY(X,Y:word);
procedure GetMouseStatus(Var Buttons,X,Y:word);
function  LeftButton:boolean;
function  RightButton:boolean;
function  CentralButton:boolean;
function  GetMouseX:word;
function  GetMouseY:word;
procedure SetLimitX(Min,Max:word);
procedure SetLimitY(Min,Max:word);
procedure LightPenEmulation(B:Boolean);
procedure GetButtonPressed(Button:word;Var Info:MouseInfo);
procedure GetButtonRelease(Button:word;Var Info:MouseInfo);
procedure GetMotionCount(Var CountX,CountY:word);
procedure SetUserMaskCall(Mask:word; UserPointer:pointer);
procedure SetSensitivity(MiskeyX,MiskeyY:word);
procedure SetGraphCursor(HotSpotX,HotSpotY:word; Var GraphBlock:MouseGraphBlock);
procedure SetTextSoftCursor(ScreenMask,CursorMask:word);
procedure SetTextHardCursor(StartScanLine,EndScanLine:word);
procedure SetDoubleSpeedThreshold(DoubleSpeed:word);
procedure DisableCursorDisplay(UpperX,UpperY,LowerX,LowerY:byte);
procedure SetUserMouseHandler(Mask:word; UserPointer:pointer);


Implementation

{$L IVMOUSE.OBJ}

procedure InitMouse;External;
Procedure ShowMouse;External;
Procedure HideMouse;External;
Procedure MouseXY(X,Y:word);External;
Procedure GetMouseStatus(Var Buttons,X,Y:word);External;
Function  LeftButton:boolean;External;
Function  RightButton:boolean;External;
Function  CentralButton:boolean;External;
Function  GetMouseX:word;External;
Function  GetMouseY:word;External;
Procedure SetLimitX(Min,Max:word);External;
Procedure SetLimitY(Min,Max:word);External;
Procedure LightPenEmulation(B:Boolean);External;
Procedure GetButtonPressed(Button:word;Var Info:MouseInfo);External;
Procedure GetButtonRelease(Button:word;Var Info:MouseInfo);External;
Procedure GetMotionCount(Var CountX,CountY:word);External;
Procedure SetUserMaskCall(Mask:word; UserPointer:pointer);External;
Procedure SetSensitivity(MiskeyX,MiskeyY:word);External;
Procedure SetGraphCursor(HotSpotX,HotSpotY:word; Var GraphBlock:MouseGraphBlock);External;
Procedure SetTextSoftCursor(ScreenMask,CursorMask:word);External;
Procedure SetTextHardCursor(StartScanLine,EndScanLine:word);External;
Procedure SetDoubleSpeedThreshold(DoubleSpeed:word);External;
Procedure DisableCursorDisplay(UpperX,UpperY,LowerX,LowerY:byte);External;
procedure SetUserMouseHandler(Mask:word; UserPointer:pointer);External;



begin
 InitMouse;
end.