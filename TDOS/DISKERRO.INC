
Function DiskErrorMessage(ErrCode:byte):String;
 Var
  S:string;
 Begin
  Case ErrCode of
   0:    S := 'Warning! CF = 1,but No Any Errors';
   1:    S := 'Invalid Function or parameter';
   2:    S := 'Address Mark not found';
   3:    S := 'Disk Write-Protected';
   4:    S := 'Sector not found';
   5:    S := 'Reset Failed';
   6:    S := 'Disk changed';
   7:    S := 'Drive parameter activity failed';
   8:    S := 'DMA Overrun';
   9:    S := 'Data boundary error';
  10:    S := 'Bad sector detected';
  11:    S := 'Bad track detected';
  12:    S := 'Invalid media';
  13:    S := 'Invalid number of sectors';
  14:    S := 'Invalid data address mark detected';
  15:    S := 'DMA arbitration level out of range';
  16:    S := 'ECC Data error';
  17:    S := 'ECC Corrected data error';
  32:    S := 'Controller Failure';
  64:    S := 'Seek Failure';
 128:    S := 'Time out';
 170:    S := 'Drive not ready';
 $BB:    S := 'Undefined error';
 $CC:    S := 'Write fault';
 $E0:    S := 'Status Error';
 $FF:    S := 'Sence operation failed'
  else    S := 'Unknown error';
 end;
 DiskErrorMessage:=S;
end;
