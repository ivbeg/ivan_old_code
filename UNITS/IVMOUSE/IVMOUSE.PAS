{$G+}
Unit IvMouse;

InterFace
Uses IvSystem;
Procedure ShowMouse;
Procedure HideMouse;
Procedure MouseXY(X,Y:word);
Procedure GetMouseStatus(Var Buttons,X,Y:word);
Function  LeftButton:boolean;
Function  RightButton:boolean;
Function  CentralButton:boolean;
Function  GetMouseX:word;
Function  GetMouseY:word;
Procedure SetLimitX(Min,Max:word);
Procedure SetLimitY(Min,Max:word);
Procedure LightPenEmulation(B:Boolean);
Procedure GetButtonPressed(Button:word;Var Info:MouseInfo);
Procedure GetButtonRelease(Button:word;Var Info:MouseInfo);
Procedure GetMotionCount(Var CountX,CountY:word);
Procedure SetUserMaskCall(Mask:word; UserPointer:pointer);
Procedure SetSensitivity(MiskeyX,MiskeyY:word);
Procedure SetGraphCursor(HotSpotX,HotSpotY:word; Var GraphBlock:MouseGraphBlock);
Procedure SetTextSoftCursor(ScreenMask,CursorMask:word);
Procedure SetTextHardCursor(StartScanLine,EndScanLine:word);
Procedure SetDoubleSpeedThreshold(DoubleSpeed:word);
Procedure DisableCursorDisplay(UpperX,UpperY,LowerX,LowerY:byte);

Implementation

{$L IVMOUSE.OBJ}

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



end.