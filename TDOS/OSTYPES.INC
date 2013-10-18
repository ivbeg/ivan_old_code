FUNCTION Get_OSType(OS_Type: Byte): String;
BEGIN
  CASE OS_Type of
   00:  Get_OSType:= 'none';
   01:  Get_OSType:= 'DOS 12-FAT';
   04:  Get_OSType:= 'DOS 16-FAT';
   05:  Get_OSType:= 'EXT DOS';
   06:  Get_OSType:= 'BIGDOS';
   12:  Get_OSType:= 'Compaq Diagnostics partition';
  $F2:  Get_OSType:= 'DOS secondary'
  ELSE  Get_OSType:= 'Unrecognized OS';
  END;
END;