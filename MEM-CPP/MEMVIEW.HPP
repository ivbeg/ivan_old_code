//****************************************************************************
//                            File MEMVIEW.HPP
//
//           Memory block identification for MEMVIEW.CPP
//------------------------------------------------------------*/
/* PROJECT              NON-PROFIT HIGH QUALITY PROFESSIONAL SOFTWARE,  */
/*                      AVAILABLE FOR ALL WORLD                         */
/* LIBRARY              SYSTEM UTILITIES                                */
/* MODULE                                                               */
/*     Copyright (c) Begtin Ivan, 1996. All rights reserved.            */
//
//****************************************************************************
//  $Archive$
// $Workfile$
//   $Author$
//     $Date$
//  $Modtime$
// $Revision$
//
//      $Log$
//
//****************************************************************************


/*----------    MEMORY_BLOCKS_INFO_CONTROL                              */
/* FILE NAME            MEMVIEW.HPP                                     */
/* PURPOSE              Softaware classes implementation                */
/* VERSION              0.12                                            */
/* DATE                 8-Apr-96                                        */
/* DESIGN               Begtin Ivan                                     */
/* IMPLEMENTATION       Begtin Ivan                                     */
/* COMPANY              none                                            */
/* COPYRIGHT NOTICE     Copyright (C) 1996, Begtin Ivan                 */
/* RESTRICTED RIGHTS    AVAILABLE ONLY FOR INTERNAL USE.                */
/*                      THIS FILE CONTAINS PROPRIETARY AND CONFIDENTIAL */
/*                      INFORMATION. COPYING AND REPRODUCTION WITHOUT   */
/*                      PRIOR WRITTEN PERMISSION IS PROHIBITED.         */
/* COMPUTER             IBM PC or compatible                            */
/* OPERATING SYSTEM     MS/PC-DOS Version 3.30 or higher                */
/* COMPILER             Any ANSI-compatible C++ compiler                */
/*                      Borland C++ 3.1                                 */
/*                       (Borland International Inc.)  or compatible    */
/* ASSEMBLY LANGUAGE    Turbo Assembler 3.1 or compatible               */
/* LINKER               Turbo Linker 5.1                                */
/* ARGUMENTS            See program on-line help                        */
/* RETURN               None                                            */
/* REQUIRES             Source Code Files                               */
/*                      None                                            */
/*                      Object Code Files                               */
/*                      None                                            */
/*                      Project Maintence Files                         */
/*                      ATAPI-CD.MAK    (auto building)                 */
/* NATURAL LANGUAGE     English Language                                */
/* SPECIAL              More easy readable debugging output             */
/*                      !!!  Result or clause                           */
/*                      >>>  program logical part                       */
/*                      <<<  command                                    */
/*                      ---  action                                     */
/*                      ->   abort or terminate                         */
/* DESCRIPTION          None                                            */
/* REVISION HISTORY                                                     */
/*----------------------------------------------------------------------*/


include "clib.h"



//---------------------------User types----------------------------------------


//---------------------------Program definitions-------------------------------
const   char  chProgramPrompt[]      =  { "MEMVIEW: " };
const   char  chVersion[]            =  { "0.1" };
const   char  chYears[]              =  { "1996" };


//---------------------------Structures Definitions----------------------------
struct sMemoryBlockInfo
{
  DWORD  Address;
  DWORD  Size;
  WORD  BlockType;
  sMemoryBlockInfo  *Owner;
  sMemoryBlockInfo  *Slave;
  MemoryBlockObject *Object;
};


///////////////////////////////////////////////////////////////////////////////
//                    --- Class MemoryBlockObject ---                      //
///////////////////////////////////////////////////////////////////////////////
class MemoryBlockObject
{
public:
    MemoryBlockObject    (const sMemoryBlockInfo*  InitInfo);
    ~MemoryBlockObject   ();

    sMemoryInfoBlock*  GetBlockInfo();
    virtual void      ReleaseBlock();
    void      DestroyBlock();
    virtual void      CreateDescription();
    virtual char*     GetBlockName();

protected:
    sMemoryBlockInfo*  BlockInfo;


private:
};
//****************************************************************************
//            --- MemoryBlockObject::MemoryBlockObject ---
//
// Purpose: (Build)Initialize Base memory block object (constructor)
//   Input: const sMemoryBlockInfo  InitInfo - Memory block info
//  Output: none
// Written: by Ivan V.Begtin 10-27-96
//****************************************************************************
MemoryBlockObject::MemoryBlockObject (const sMemoryBlockInfo*  InitInfo);
{
    BlockInfo = InitInfo;

}






















































