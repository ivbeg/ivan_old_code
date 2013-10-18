Unit Equ;

interface

const
     hcInformation   = 6000;
     hcSysInfo       = hcInformation + 1;
     hcMcbList       = hcSysInfo + 1;
     hcUmbList       = hcMcbList + 1;
     hcDevList       = hcUmbList + 1;
     hcAbout         = hcDevList + 1;

     cmSysInfo       = 100;
     cmMcbList       = cmSysInfo + 1;
     cmUmbList       = cmMcbList + 1;
     cmDevList       = cmUmbList + 1;
     cmAbout         = cmDevList + 1;

     mcb_type_Program          = 00;
     mcb_type_DeviceDriver     = mcb_type_Program + 1;
     mcb_type_Sft              = mcb_type_DeviceDriver + 1;
     mcb_type_SystemData       = mcb_type_Sft + 1;
     mcb_type_SystemCode       = mcb_type_SystemData + 1;
     mcb_type_ProgramData      = mcb_type_SystemCode + 1;
     mcb_type_DeviceAppendage  = mcb_type_ProgramData + 1;
     mcb_type_FcbTable         = mcb_type_DeviceAppendage + 1;
     mcb_type_Buffers          = mcb_type_FcbTable + 1;
     mcb_type_EmsBuffers       = mcb_type_Buffers + 1;
     mcb_type_Stacks           = mcb_type_EmsBuffers + 1;
     mcb_type_FreeMemory       = mcb_type_Stacks + 1;
     mcb_type_CurrentDir       = mcb_type_FreeMemory + 1;
     mcb_type_Environment      = mcb_type_CurrentDir + 1;
     mcb_type_IfsDriver        = mcb_type_Environment + 1;


implementation

Begin
End.
