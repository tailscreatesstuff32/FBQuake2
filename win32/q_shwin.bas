' WORK IN PROGRESS''''''''''''''''''''''''''''''''''''


#Include "qcommon\qcommon.bi"

#include "winquake.bi"
'#include <errno.h>
'#include <fcntl.h>
'#include <stdio.h>
'#include <direct.h>
'#include <io.h>
'#include <conio.h>


dim shared hunkcount as integer		

dim shared  membase as ubyte ptr
dim shared hunkmaxsize as Integer
dim shared 	cursize as Integer




dim shared findbase as zstring * MAX_OSPATH
dim shared findpath as zstring * MAX_OSPATH
dim shared findhandle as integer


#define	VIRTUAL_ALLOC


sub	Sys_Mkdir (path as ZString ptr) 
	
	_mkdir (path) 
	
End Sub
 
 
function _Hunk_Begin ( maxsize as  integer) As any ptr
 
	'// reserve a huge chunk of memory, but don't commit any yet
	cursize = 0 
	hunkmaxsize = maxsize 
#ifdef VIRTUAL_ALLOC
	membase = VirtualAlloc (NULL, maxsize, MEM_RESERVE, PAGE_NOACCESS) 
#else
	membase = malloc (maxsize) 
	memset (membase, 0, maxsize) 
#endif
	if ( membase = NULL) then
		Sys_Error ("VirtualAlloc reserve failed") 
	EndIf
		
		
		
	return  cast(any ptr,membase)
	
end function
 
 
	function Hunk_Begin ( maxsize as  integer) As any ptr
 
	'// reserve a huge chunk of memory, but don't commit any yet
	cursize = 0 
	hunkmaxsize = maxsize 
#ifdef VIRTUAL_ALLOC
	membase = VirtualAlloc (NULL, maxsize, MEM_RESERVE, PAGE_NOACCESS) 
#else
	membase = malloc (maxsize) 
	memset (membase, 0, maxsize) 
#endif
	if ( membase = NULL) then
		'Sys_Error ("VirtualAlloc reserve failed");
	EndIf
		
		
		
	return  cast(any ptr,membase)
	
end function
 
 
 sub  _Hunk_Free (_base as any ptr) 
 	
 	
 	 
 		if ( _base <> NULL ) then
#ifdef VIRTUAL_ALLOC
		 VirtualFree (_base, 0, MEM_RELEASE) 
#else
	    free (_base) 
#endif
 		end if
 		
	hunkcount-=1
 

 	
 	
 	
 End sub
 
 
 sub  Hunk_Free (_base as any ptr) 
 	
 	
 	 
 		if ( _base <> NULL ) then
#ifdef VIRTUAL_ALLOC
		 VirtualFree (_base, 0, MEM_RELEASE) 
#else
	    free (_base) 
#endif
 		end if
 		
	hunkcount-=1
 

 	
 	
 	
 End sub
 




function _Hunk_End () as Integer
 
'	// free the remaining unused virtual memory
#if 0
	dim buf any ptr

	'// write protect it
	buf = VirtualAlloc (membase, cursize, MEM_COMMIT, PAGE_READONLY) 
	if (buf) then
	'	Sys_Error ("VirtualAlloc commit failed")
	printf(!"VirtualAlloc commit failed/n") 
	end if	 
#endif

	hunkcount+=1
'//Com_Printf ("hunkcount: %i\n", hunkcount);
	return cursize 
end function
 
function _Hunk_Alloc (_size as Integer ) as any ptr
 	
 	
dim buf as any ptr

	'// round to cacheline
	_size = (_size+31)and not 31 

#ifdef VIRTUAL_ALLOC
	'// commit pages as needed
'//	buf = VirtualAlloc (membase+cursize, size, MEM_COMMIT, PAGE_READWRITE);
	buf = VirtualAlloc (membase, cursize+_size, MEM_COMMIT, PAGE_READWRITE) 
	
	'print buf
	'sleep
	
	
	
	if (buf = NULL) then
		
			 
	 FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),  cast(LPTSTR, @buf), 0, NULL) 
		'Sys_Error ("VirtualAlloc commit failed.\n%s", buf);
	EndIf

 
#endif
	cursize += _size
	if (cursize > hunkmaxsize) then
		'Sys_Error ("Hunk_Alloc overflow") 

	EndIf
		

		return cast(any ptr,(membase+cursize-_size)) 	
	
	
	
 End function






function Hunk_End () as Integer
 
'	// free the remaining unused virtual memory
#if 0
	dim buf any ptr

	'// write protect it
	buf = VirtualAlloc (membase, cursize, MEM_COMMIT, PAGE_READONLY) 
	if (buf) then
	'	Sys_Error ("VirtualAlloc commit failed")
	printf(!"VirtualAlloc commit failed/n") 
	end if	 
#endif

	hunkcount+=1
'//Com_Printf ("hunkcount: %i\n", hunkcount);
	return cursize 
end function
 
function Hunk_Alloc (_size as Integer ) as any ptr
 	
 	
dim buf as any ptr

	'// round to cacheline
	_size = (_size+31)and not 31 

#ifdef VIRTUAL_ALLOC
	'// commit pages as needed
'//	buf = VirtualAlloc (membase+cursize, size, MEM_COMMIT, PAGE_READWRITE);
	buf = VirtualAlloc (membase, cursize+_size, MEM_COMMIT, PAGE_READWRITE) 
	
	'print buf
	'sleep
	
	
	
	if (buf = NULL) then
		
			 
	 FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),  cast(LPTSTR, @buf), 0, NULL) 
		'Sys_Error ("VirtualAlloc commit failed.\n%s", buf);
	EndIf

 
#endif
	cursize += _size
	if (cursize > hunkmaxsize) then
		'Sys_Error ("Hunk_Alloc overflow") 

	EndIf
		

		return cast(any ptr,(membase+cursize-_size)) 	
	
	
	
 End function













'/*
'================
'Sys_Milliseconds
'================
'*/
dim shared curtime as integer
function Sys_Milliseconds () as integer
	
 
	static	_base as integer	
	static initialized as qboolean	 = _false 

	if (initialized = _false) then
	 '	// let base retain 16 bits of effectively random data
		_base = timeGetTime() and &Hffff0000 
		initialized = _true 
	end if
	
	curtime = timeGetTime() - _base 

	return curtime 

	
End Function

function CompareAttributes( found  as UInteger  , musthave as UInteger,canthave as uinteger )   as qboolean static

 	if ( ( found and _A_RDONLY ) and ( canthave and SFF_RDONLY ) ) then
 		return _false 
 	EndIf
 	if ( ( found and _A_HIDDEN ) and ( canthave and SFF_HIDDEN ) ) then
 		return _false 
 	EndIf
   if ( ( found and _A_SYSTEM  ) and ( canthave and SFF_SYSTEM ) ) then
 		return _false 
   EndIf
 	 if ( ( found and _A_SUBDIR  ) and ( canthave and SFF_SUBDIR ) ) then
 		return _false 
   EndIf
 	if ( ( found and _A_ARCH  ) and ( canthave and SFF_ARCH ) ) then
 		return _false 
 	EndIf
 
 
 if ( ( musthave and SFF_RDONLY ) and  ( found and _A_RDONLY ) = _false) then
 	return _false
 EndIf
  	 if ( ( musthave and SFF_HIDDEN  ) and  ( found and _A_HIDDEN ) = _false) then
 	return _false
 EndIf
  if ( ( musthave and SFF_SYSTEM ) and  ( found and _A_SYSTEM ) = _false) then
 	return _false
 EndIf
 if ( ( musthave and SFF_SUBDIR ) and  ( found and  _A_SUBDIR ) = _false) then
 	return _false
 EndIf
 if ( ( musthave and SFF_ARCH ) and  ( found and _A_ARCH  ) = _false) then
 	return _false
 EndIf
   
 
 return _false 
end function


 

function Sys_FindFirst (path as zstring ptr, musthave as UInteger, canthave as UInteger) as zstring ptr
	 dim findinfo as _finddata_t

  if (findhandle) then
  	 Sys_Error ("Sys_BeginFind without close")
  	findhandle = 0
  EndIf
 
 	COM_FilePath (path, findbase) 
 	findhandle = _findfirst (path, @findinfo) 
 	if (findhandle = -1) then
 		return NULL
 	EndIf
 		
 
 	if ( CompareAttributes( findinfo.attrib, musthave, canthave ) = 0) then
 		return NULL
 	EndIf
 
 	Com_sprintf (findpath, sizeof(findpath), "%s/%s", findbase, findinfo.name) 
 	return @findpath 
 
End Function
 

'char *Sys_FindNext ( unsigned musthave, unsigned canthave )
'{'
'	struct _finddata_t findinfo;'

'	if (findhandle == -1)
'		return NULL;
'	if (_findnext (findhandle, &findinfo) == -1)
'		return NULL;
'	if ( !CompareAttributes( findinfo.attrib, musthave, canthave ) )
'		return NULL;
'
'	Com_sprintf (findpath, sizeof(findpath), "%s/%s", findbase, findinfo.name);
'	return findpath;
'}


sub Sys_FindClose ()
 if (findhandle <> -1) then
 	
 	_findclose (findhandle)
 	findhandle = 0 
 EndIf
 	 
 
	
End Sub
 
 
 
 