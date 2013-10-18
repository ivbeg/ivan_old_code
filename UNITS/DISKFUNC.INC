Const
 MessageSize = $40;
 DiskFunctions : Array[0..$18] of String[MessageSize] =
  ('Reset Disk System',
   'Get Last Operation status',
   'Read Sector(s) into memory',
   'Write Disk Sector(s)',
   'Verify Disk Sector(s)',
   'Format disk track',
   'Format track (XT,PORT)',
   'Format Fixed disk (XT,PORT)',
   'Get Disk Parameters (PC,XT286,CONV,PS,ESDI,SCSI)',
   'Initialise hard disk controller (AT,PS)',
   'Read hard disk Long Sector(s) (AT+)',
   'Write hard disk long Sector(s)',
   'Seek to hard disk cyllinder',
   'Reset hard disks',
   'Read sector buffer (XT)',
   'Write sector buffer (XT)',
   'Check hard disk ready',
   'Recalibrate hard disk',
   'Hard disk Controller Ram diagnostic (XT,PS)',
   'Hard disk diagnostic (XT,PS)',
   'Hard disks controller internal diagnostic',
   'Get disk type',
   'Get Floppy disk change',
   'Set floppy disk type for format',
   'Set disk media type for format');






