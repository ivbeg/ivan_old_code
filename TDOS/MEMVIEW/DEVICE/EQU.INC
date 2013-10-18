Type
    TMessage          = System.Word;

    TSystemData_Code  = array[1..2] of System.Char;
    TString7          = String[7];
    TString3          = String[3];
    

Const
     block_mess_GetDescription   = $0100;

     block_type_Program          = 00;
     block_type_DeviceDriver     = 01;
     block_type_SystemData       = 02;
     block_type_SystemCode       = 03;
     block_type_ProgramData      = 04;
     block_type_DeviceAppendage  = 05;
     block_type_FcbTable         = 06;
     block_type_Buffers          = 07;
     block_type_EmsBuffers       = 08;
     block_type_Stacks           = 09;
     block_type_FreeMemory       = 10;
     block_type_CurrentDir       = 11;
     block_type_IfsDriver        = 12;
     block_type_ROM              = 13;
     block_type_IO_SYS           = 14;
     block_type_IntTable         = 15;
     block_type_BiosDataArea     = 16;
     block_type_DosDataArea      = 17;
     block_type_VideoRAM         = 18;

     prg_type_Mouse              = 00;
     prg_type_COMMAND            = 01;
     prg_type_4DOS               = 02;
     prg_type_NDOS               = 03;
     prg_type_WIN                = 04;
     prg_type_NC                 = 05;
     prg_type_DN                 = 06;
     prg_type_SMARTDRV           = 07;
     prg_type_KEYB               = 08;
     prg_type_MSCDEX             = 09;
     prg_type_PRINT              = 10;

     mcb_sign_DeviceDriver       = $44;
     mcb_sign_FilesTable         = $46;
     mcb_sign_Buffers            = $58;
     mcb_sign_FcbTable           = $40;
     mcb_sign_EmsBuffers         = $43;
     mcb_sign_Stacks             = $53;
     mcb_sign_CurrentDir         = $4C;
     mcb_sign_IfsDriver          = $49;
     mcb_sign_DeviceAppendage    = $45;
     
        {** character device flag **}
     dfCharDevice                = $8000;

     mcb_flag_NoName             = 01;
     mcb_flag_StrangeName        = 02;
     mcb_flag_EndOfChain         = 04;

     mcb_owner_FreeMemory        = $0000;
     mcb_owner_IOSYS             = $0008;

     mcb_name_SystemData         = 'SD';
     mcb_name_SystemCode         = 'SC';
     mcb_name_None               = 'Unnamed';


     mcb_error_ErrorInChain      = 01;
     mcb_segm_RamEnd             = $9FFF;


     prg_flag_NoEnvironment      = 01;
     prg_flag_AlienEnvironment   = 02;
     prg_flag_CurrentProgram     = 04;
    