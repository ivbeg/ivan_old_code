Var
          { ** Global Variables ** }
    S:string;

          { ** Lists of Memory Blocks ** }
    DevArr:array[1..30] of DevBlock;
    DptArr:array[1..20] of DptBlock;
    EmsArr:array[1..30] of EmsBlock;
    XmsArr:array[0..20] of XmsBlock;
    CountEms,CountDev,CountMcb,CountXms,CountSft,CountDpt,CountPrg:word;
    Count:word;

             {** Xms Info ** }
    XmsFrHandles:word;
    XmsTotHandles:word;
    XmsLineA20:boolean;
    XmsFreeBlock:LongInt;
    XmsMaxFreeSize:LongInt;
    XmsVersion:string[3];
    XmsRevision:string[3];

             {** Ems Info ** }
    EmsTotMemory:LongInt;
    EmsFreeMemory:LongInt;
    EmsPageFrame:Word;
    EmsFrHandles:word;
    EmsTotHandles:word;
    EmsVer:word;


