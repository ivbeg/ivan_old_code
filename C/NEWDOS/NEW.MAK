.AUTODEPEND

#               *Translator Definitions*
CC = bcc +NEW.CFG
TASM = TASM
TLIB = tlib
TLINK = tlink
LIBPATH = H:\BC31\LIB
INCLUDEPATH = H:\BC31\INCLUDE


#               *Implicit Rules*
.c.obj:
  $(CC) -c {$< }

.cpp.obj:
  $(CC) -c {$< }

#               *List Macros*


EXE_dependencies =  \
 c_newdos.obj \
 newdos.obj

#               *Explicit Rules*
new.exe: new.cfg $(EXE_dependencies)
  $(TLINK) /v/s/c/P-/Vt/L$(LIBPATH) @&&|
c0l.obj+
c_newdos.obj+
newdos.obj
new,new
fp87.lib+
mathl.lib+
cl.lib
|


#               *Individual File Dependencies*
c_newdos.obj: new.cfg c_newdos.cpp

#               *Compiler Configuration File*
new.cfg: new.mak
  copy &&|
-R
-ml
-3
-f287
-v
-y
-vi-
-wpro
-weas
-wpre
-I$(INCLUDEPATH)
-L$(LIBPATH)
| new.cfg


