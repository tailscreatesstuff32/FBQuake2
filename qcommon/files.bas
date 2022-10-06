#Include "qcommon\qcommon.bi"
#include "crt\stdlib.bi"


'// define this to dissalow any data but the demo pak file
'//#define	NO_ADDONS
'
'// if a packfile directory differs from this, it is assumed to be hacked
'// Full version
#define	PAK0_CHECKSUM	&H40e614e0
'// Demo
'//#define	PAK0_CHECKSUM	&Hb2c6d7ea
'// OEM
'//#define	PAK0_CHECKSUM	&H78e135c

'void CDAudio_Stop(void);
#define	MAX_READ	&H10000		'// read in blocks of 64k

 
'//
'// in memory
'//

type packfile_t
  _name as zstring * MAX_QPATH  
  as integer _filepos, _filelen 
	
End Type
 
 
type pack_s
	filename  as zstring * MAX_OSPATH 
	handle  as FILE ptr
	 numfiles  as Integer
	 _files  as packfile_t ptr
	
	
End Type: type  pack_t  as pack_s
 
 

 
		
dim shared  _fs_gamedir as zstring * MAX_OSPATH
 
dim shared  fs_basedir as cvar_t	ptr
dim shared  fs_cddir  as cvar_t	ptr
dim shared  fs_gamedirvar  as cvar_t	ptr

type filelink_s
	_next 	as filelink_s	ptr
	_from  as zstring ptr
	fromlength  as integer		
	_to as zstring ptr


	
End Type:type  filelink_t as filelink_s
 

dim shared fs_links  as filelink_t	ptr

type  searchpath_s
 filename as zstring * MAX_OSPATH
 
	pack  as pack_t ptr		 
   _next as searchpath_s ptr 
End Type: type searchpath_t as searchpath_s

dim shared fs_searchpaths as searchpath_t	ptr
dim shared fs_base_searchpaths  as searchpath_t ptr



 




'WORKS FINE''''''''''''''''''''''''''''''''''''''''
 function FS_filelength (f as FILE ptr) as Integer
 	
 	dim _pos  as integer		
	dim _end  as integer	

	_pos = ftell (f) 
	fseek (f, 0, SEEK_END) 
	_end = ftell (f) 
	fseek (f, _pos, SEEK_SET) 

	return _end 

 	
 End Function










'WORKS FINE''''''''''''''''''''''''''''''''''''''''''''''''''''''
sub FS_Read (buffer as any ptr,_len as integer ,f as  FILE ptr)
 
	dim  as integer		block, remaining 
	 dim as integer  read_ 
	dim buf as ubyte	ptr
	 dim as integer		tries 

	 buf = cast(ubyte ptr, buffer) 

	'// read in chunks for progress bar
 
	  remaining =  _len  

	  tries = 0 
	 do  while  remaining 
	  
 		 block = remaining 
	 if (block > MAX_READ) then
	  block = MAX_READ 
	 end if	
	  
	   read_ =   fread (buf, 1,  block , f)
	 	
 	if (read_  = 0) then
 
	 '		// we might have been trying to read from a CD
	 		if ( tries = 0) then
 
 	 		tries = 1 
	 '		//	CDAudio_Stop();
	  
	 		else
	 		'Com_Error (ERR_FATAL, "FS_Read: 0 bytes read");
	 		end if

	  	if (read_ =  -1) then
    	'Com_Error (ERR_FATAL, "FS_Read: -1 bytes read");
	 	end if
	 '	// do some progress bar thing here...

	' 
	' 	
	  end if	
	 		remaining -=  read_ 
	   buf += read_
	 loop
	 
	 

	 
	' 	
end sub

'/*
'=============
'FS_FreeFile
'=============
'*/
sub FS_FreeFile ( buffer as any ptr)
	Z_Free (buffer) 
End Sub


'/*
'===========
'FS_FOpenFile
'
'Finds the file in the search path.
'returns filesize and an open FILE *
'Used for streaming data out of either a pak file or
'a seperate file.
'===========
'*/




sub FS_ExecAutoexec()
	dim as zstring ptr _dir 
	dim  as zstring * MAX_QPATH _name 

	_dir = Cvar_VariableString("gamedir") 
	if (*_dir) then
		Com_sprintf(_name, sizeof(_name), !"%s/%s/autoexec.cfg", fs_basedir->_string, _dir)  
	else
		Com_sprintf(_name, sizeof(_name), !"%s/%s/autoexec.cfg", fs_basedir->_string, BASEDIRNAME)  
	end if
	if (Sys_FindFirst(_name, 0, SFF_SUBDIR or SFF_HIDDEN or SFF_SYSTEM)) then	 
		Cbuf_AddText (!"exec autoexec.cfg\n") 
	EndIf
		
	Sys_FindClose() 
	
	
	
End Sub










dim shared as Integer file_from_pak = 0
#ifndef NO_ADDONS
'WORKS FINE BUT NOT FULLY ADDED
function FS_FOpenFile  ( filename as ZString ptr,_file as FILE ptr ptr) as Integer
 
	dim search  as searchpath_t	ptr
	dim netpath as zstring * (MAX_OSPATH) 			
	dim pak as pack_t ptr
	dim i  as integer				 
	dim _link  as filelink_t ptr

	file_from_pak = 0 

	'// check for links first
	
	
 
 
if _link <> null then
	
#ifdef 0


 
	'_link = fs_links 
	'do while _link
	'	
	'	   if ( strncmp (filename, _link->_from, _link->fromlength) = 0) then
	'	 
	'		 Com_sprintf (netpath, sizeof(netpath), "%s%s",link->to, filename+link->fromlength) 
	'	 *_file = fopen (filename, "rb") 
	'		 if (*_file <> null) then
	'		 		
	'			 Com_DPrintf ("link file: %s\n",netpath) 
	'			 return  FS_filelength (*_file) 
	'		 end if
	'		 
	'		 return -1 
 	'	 	end if
	'	
	'	_link=_link->_next
	'Loop
#Endif	
			
else
	
	 '*_file = fopen (filename, "rb") 
		'	 if (*_file <> null) then
			 		
			'	Com_DPrintf ("link file: %s\n",netpath) 
		'		 return  FS_filelength (*_file) 
		'	 end if
			 
			' return -1 
EndIf
 
			

'search =  fs_searchpaths
'do while search
'	
'	
'	
'	 
'	
'if (search->pack) then 
'	 
'       	exit do
'  end if   	
'    	
'if (search = NULL) then
'	*_file = NULL
'
'	return -1 
'
'EndIf
'		
' search = search->_next	
'
'
'
'
'
'
'Loop
' 
' pak =  search->pack
' 
' 
''print pak->_files[0]._name  
' 
'
' 
' 	 for  i=0  to  pak->numfiles-1  
' 	   'print pak->_files[i]._name'["found"
' 			if ( Q_strcasecmp (pak->_files[i]._name, filename) = 0) then
' 				file_from_pak = 1
' 				'Com_DPrintf ("PackFile: %s : %s\n",pak->filename, filename);
' 				 
' 			 	printf(!"PackFile: %s : %s\n",pak->filename, filename)
' 			 	'print  "PackFile: " & pak->filename & " : "  & *filename 
' 		
'		 '// found it!
'			 
'		'if pak->_files[i]._name = "e1u1\crate1_1.wal" then
'		
'		
'		'end if
'		'sleep
'
'
'		'// open a new file on the pakfile
'			* _file = fopen (pak->filename, "rb") 
'			if ( *_file = NULL) then
'		 
'				 'Com_Error (ERR_FATAL, "Couldn't reopen %s", pak->filename)
'			print "error"
'			return -1	 
'				end if	 	
'			fseek (*_file, pak->_files[i]._filepos, SEEK_SET) 
'			return pak->_files[i]._filelen 
'		
' 	
' 	
' 		EndIf
' 	
' 	  Next
' 
'''	
'''	Com_DPrintf ("FindFile: can't find %s\n", filename);
'''	
'	printf(!"FindFile: can't find %s\n", filename)
'	'print "FindFile: can't find " & *filename
	
	 
	 
	 
	 
	 
	 
	 
'	 
 search =  fs_searchpaths
 
 
 '
 'print search->pack
 '
 'sleep
 '
 
 
'
'print fs_searchpaths->pack


'return -1


'sleep

'print	search
'print search->pack
'search = search->_next
'print search
'print search->pack
'	 	
'sleep	
' 
					
do while search

 
if (search->pack) then 	 
 
 pak =  search->pack	
 
 

 	 for  i=0  to  pak->numfiles-1  
 			if ( Q_strcasecmp (pak->_files[i]._name, filename) = 0) then
 			 '// found it!
 				file_from_pak = 1
 				'Com_DPrintf ("PackFile: %s : %s\n",pak->filename, filename);
 			 	printf(!"PackFile: %s : %s\n",pak->filename, filename)
		'// open a new file on the pakfile
			* _file = fopen (pak->filename, "rb") 
			if ( *_file = NULL) then
		 
				 Com_Error (ERR_FATAL, "Couldn't reopen %s", pak->filename)
			'print "error"
  
				end if	 	
			fseek (*_file, pak->_files[i]._filepos, SEEK_SET) 
			return pak->_files[i]._filelen 
		
 	
 	
 		EndIf
 	
 	  Next
 
 else
 
 
     '	// check a file in the directory tree
			
   
			Com_sprintf (netpath, sizeof(netpath), "%s/%s",search->filename, filename) 
 
			*_file = fopen (netpath, "rb") 
			if ( *_file = NULL) then
			
		 search = search->_next
					continue do
					
			EndIf
			 
			
			'Com_DPrintf (!"FindFile: %s\n",netpath) 

			return FS_filelength (*_file) 
	 end if
 
 
 search = search->_next
 
Loop


''	
''	Com_DPrintf ("FindFile: can't find %s\n", filename);
''	
	printf(!"FindFile: can't find %s\n", filename)
'	'print "FindFile: can't find " & *filename
'	 

   *_file = NULL  
  	 return -1 
end function
''
'
'


 #else
'
'// this is just for demos to prevent add on hacking
'
'function FS_FOpenFile  ( filename as ZString ptr,_file as FILE ptr ptr) as Integer
'
' 	dim search  as searchpath_t ptr
' 	dim netpath as zstring *  MAX_OSPATH	 
' 	dim pak as pack_t ptr
' 	
' 			 
' 	i  as integer				
''
' 	file_from_pak = 0 
''
' '	// get config from directory, everything else from pak
' 	if ((strcmp(filename, "config.cfg") = 0) or (strncmp(filename, "players/", 8) = 0)) then
' 
'   '	Com_sprintf (netpath, sizeof(netpath), "%s/%s",FS_Gamedir(), filename);
''		
' 	*_file = fopen (netpath, "rb") 
'   	if (*_file) then
'  		return -1 
'  		
' 
'  		
''		
''		Com_DPrintf ("FindFile: %s\n",netpath);
''
' 	return FS_filelength (*_file) 
'   	end if
'   	
'   	
'   	
'   	
'   	
'   	
''
' 'for (search = fs_searchpaths ; search ; search = search->next)
'   ' do 
' 	'  if (search->pack) then 
'   '      	exit for 
' 	'  end if   	
'   '      	
' 	'if (search = NULL) then
' 	'	*file = NULL
' 	' 
'   ' 	return -1 
' 	'	
' 	'EndIf
' 
''
''	pak = search->pack;
''	for (i=0 ; i<pak->numfiles ; i++)
''		if (!Q_strcasecmp (pak->files[i].name, filename))
''		{	// found it!
''			file_from_pak = 1;
''			Com_DPrintf ("PackFile: %s : %s\n",pak->filename, filename);
''		// open a new file on the pakfile
''			*file = fopen (pak->filename, "rb");
''			if (!*file)
''				Com_Error (ERR_FATAL, "Couldn't reopen %s", pak->filename);	
''			fseek (*file, pak->files[i].filepos, SEEK_SET);
''			return pak->files[i].filelen;
''		}
''	
''	Com_DPrintf ("FindFile: can't find %s\n", filename);
''	
' 	*file = NULL  
' 	return -1 
'end function
'
 #endif







'/*
'================
'FS_NextPath
'
'Allows enumerating all of the directories in the search path
'================
'*/
 function FS_NextPath (prevpath as zstring ptr) as zstring	ptr 
 
	dim as searchpath_t ptr s 
	dim as zstring	ptr  prev  

	if (prevpath = NULL) then
			return fs_gamedir 
	EndIf
	
	prev = fs_gamedir 
	s=fs_searchpaths
	
	s=fs_searchpaths
	 do while s 
	 	
	 if (s->pack) then
	 	   s=s->_next
			continue do
		end if
		if (prevpath = prev) then
			return @s->filename
		end if
		prev = @s->filename 
 
	 	s=s->_next
	 Loop
	
	 
	

	return NULL 
 end function
 
'FS_LoadFile
'
'Filename are reletive to the quake search path
'a null buffer will just return the file length without loading
'============
'*/

'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FS_LoadFile (path as zstring ptr, _buffer as any ptr ptr) as integer
	
	dim h as FILE ptr 
	dim buf as ubyte	ptr 
	dim _len  as integer		
   dim _buff  as any ptr ptr


	buf =   NULL '	// quiet compiler warning

'// look for it in the filesystem or pack files
	_len = FS_FOpenFile(path, @h) 
'print  (_len)
	
	if (h = NULL) then
			if (_buffer <> null) then
			*_buffer = NULL 
		return -1
			EndIf
		
	EndIf
	
	if ( _buffer = null) then
			fclose (h) 	
		return _len 
	 
 
	EndIf
 
	   buf  = Z_Malloc(_len)
	  *_buffer =   buf
	 FS_Read (buf, _len, h)

	  fclose (h)

	return _len
	
	
	
	
	
End Function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FS_Gamedir () as ZString ptr

	  if (_fs_gamedir[0]) then
	  	return @_fs_gamedir 
	 else
	  	return @BASEDIRNAME 
	 end if
End Function
 
 
 
function FS_LoadPackFile (packfile as zstring ptr) as pack_t ptr
 
	dim header    as     dpackheader_t	 
	dim i         as     integer				
	dim newfiles  as     packfile_t ptr 
	dim numpackfiles	as	  integer
	dim pack        as     pack_t ptr 
	dim packhandle  as    FILE ptr
	dim info(MAX_FILES_IN_PACK)  as dpackfile_t		
	 dim checksum as uinteger

	packhandle = fopen(packfile, "rb")
	
 
	 
	if ( packhandle = NULL) then
		return NULL
	end if 
  
	fread (@header, 1, sizeof(header), packhandle) 
	  
	  
	 'dim temp_ as ZString*50
	 'itoa(LittleLong(header.ident),@temp_,16)
	 
 
	' print chr(header.ident and &HFF) & chr((LittleLong(header.ident) and &H0000FF00) shr 8) & chr((LittleLong(header.ident) and &H00FF0000) shr 16) & chr((LittleLong(header.ident) and &HFF000000) shr 24)
	 
	 
 
	if (LittleLong(header.ident) <> IDPAKHEADER) then
		'Com_Error (ERR_FATAL, "%s is not a packfile", packfile)
		printf(!"%s is not a packfile", packfile)
	end if
	header.dirofs = LittleLong (header.dirofs) 
	header.dirlen = LittleLong (header.dirlen) 
	
	'print header.dirofs
	'print header.dirlen
	'print  header.dirlen / sizeof(dpackfile_t) 

	numpackfiles = header.dirlen / sizeof(dpackfile_t) 

   



	if (numpackfiles > MAX_FILES_IN_PACK) then
		'Com_Error (ERR_FATAL, "%s has %i files", packfile, numpackfiles)
		printf(!"%s has %i files", packfile, numpackfiles)
		
	end if

	newfiles = Z_Malloc (numpackfiles * sizeof(packfile_t)) 

	fseek (packhandle, header.dirofs, SEEK_SET )
	fread (@info(0), 1, header.dirlen, packhandle) 


 'NOT FINISHED 
 #ifdef 0
 
'// crc the directory to check for modifications
	 checksum = Com_BlockChecksum (cast(any ptr, @info(0)) , header.dirlen)

#ifdef NO_ADDONS
	if (checksum = PAK0_CHECKSUM)
		 return NULL 
	end if
#endif


#endif


'// parse the directory
	 
	 for i = 0 to numpackfiles-1
		strcpy (newfiles[i]._name, info(i)._name) 
		newfiles[i]._filepos = LittleLong(info(i)._filepos) 
		newfiles[i]._filelen = LittleLong(info(i)._filelen) 
	next

	pack = Z_Malloc (sizeof (pack_t)) 
	strcpy (pack->filename, packfile) 
	pack->handle = packhandle 
	pack->numfiles = numpackfiles 
	pack->_files =  newfiles  
	
   
	
	'Com_Printf ("Added packfile %s (%i files)\n", packfile, numpackfiles);
	Printf (!"Added packfile %s (%i files)\n", packfile, numpackfiles)
	 'print "Added packfile "& *packfile & " (" & numpackfiles & " files)"
	'sleep 
	return pack
 


end function


'dim pakfile as ZString * MAX_OSPATH		
	' print sizeof(pakfile)
 '	sleep

sub  FS_AddGameDirectory (_dir as zstring ptr)
	dim as integer	i 			
	dim search  as searchpath_t	ptr
	dim pak as pack_t ptr
	dim pakfile as ZString * MAX_OSPATH			

	strcpy (_fs_gamedir, _dir) 

	'//
	'// add the directory to the search path
	'//
	search = Z_Malloc (sizeof(searchpath_t)) 
	strcpy (search->filename, _dir) 
	search->_next = fs_searchpaths 
	fs_searchpaths = search 
 		 ' print search
     'print search->_next
     'print fs_searchpaths
     'sleep
		
 

	'//
	'// add any pak files in the format pak0.pak pak1.pak, ...
	'//
	for  i= 0 to 10-1 
	 Com_sprintf (pakfile, sizeof(pakfile), "%s/pak%i.pak", _dir, i) 
 
		pak = FS_LoadPackFile (pakfile)
 
		if ( pak = NULL) then
		
			continue for
		end if
	
		search = Z_Malloc (sizeof(searchpath_t))
		search->pack = pak 
		search->_next = fs_searchpaths 
		fs_searchpaths = search 	
		
	
		
	Next
	 
 'print "out!"
 'print search->pack
 'print fs_searchpaths
 '
 
	
End Sub
 
 
 sub FS_Path_f
 	
 	
 End Sub
  sub FS_Link_f
 	
 	
 End Sub
 
  sub FS_Dir_f 

 	
 	
 End Sub
 
     'FS_AddGameDirectory (_va("%s/"BASEDIRNAME, ".") ) 
     'FS_AddGameDirectory (_va("H:\install\data/"BASEDIRNAME )) 
   
   
   
   
   
'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''   
sub FS_InitFilesystem ()
 
 	Cmd_AddCommand ("path", @FS_Path_f) 
	 Cmd_AddCommand ("link", @FS_Link_f) 
    Cmd_AddCommand ("dir", @FS_Dir_f ) 
'
'	//
'	// basedir <path>
'	// allows the game to run from outside the data tree
'	//
  fs_basedir =   Cvar_Get ("basedir", ".", CVAR_NOSET) 
  
 
'
'	//
'	// cddir <path>
'	// Logically concatenates the cddir after the basedir for 
'	// allows the game to run from outside the data tree
'	//
 	fs_cddir = Cvar_Get ("cddir", "", CVAR_NOSET) 
 	if (fs_cddir->_string[0]) then
 		FS_AddGameDirectory (_va("%s/"BASEDIRNAME, fs_cddir->_string) ) 
 	EndIf
 '	
'
'	//
'	// start up with baseq2 by default
'	//
    FS_AddGameDirectory (_va("%s/"BASEDIRNAME, fs_basedir->_string) ) 
   
'
'	// check for game override
 	fs_gamedirvar = Cvar_Get ("game", "", CVAR_LATCH or _CVAR_SERVERINFO) 
 
  
 	
 	
 	  if (fs_gamedirvar->_string[0] <> NULL) then
    	FS_SetGamedir (fs_gamedirvar->_string)  
 	 
 	  EndIf
  

 end sub	
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



''MIGHT DELETE
'sub shut_down1()
'	
'		dim	_next as searchpath_t ptr	
'	
'	   
''
''	// any set gamedirs will be freed up to here
' 	 fs_base_searchpaths = fs_searchpaths 
' 	 
' 	 	while (fs_searchpaths <>fs_base_searchpaths)
' 	 		if (fs_searchpaths->pack) then
' 	 			fclose (fs_searchpaths->pack->handle) 
'				Z_Free (fs_searchpaths->pack->_files) 
'				Z_Free (fs_searchpaths->pack)
'			
'			
'	 
' 	 		EndIf
' 	 		
' 	 	_next = fs_searchpaths->_next 
'		Z_Free (fs_searchpaths) 
'		fs_searchpaths = _next 
' 	
' 	 	Wend
'	
'End Sub


sub  FS_SetGamedir(_dir as zstring ptr)
		dim as searchpath_t	ptr _next 

	if (strstr(_dir, !"..") <> NULL or strstr(_dir, !"/") <> NULL  _
		or strstr(_dir, !"\\") <> NULL  or strstr(_dir, !":") <> NULL)   then
		
	 	
	 	Com_Printf (!"Gamedir should be a single filename, not a path\n") 
	 	return 
	 end if

 
	'// free up any current game dir info
 

	'// any set gamedirs will be freed up to here
 	 fs_base_searchpaths = fs_searchpaths 
 	 
 	 	while (fs_searchpaths <> fs_base_searchpaths)
 	 		if (fs_searchpaths->pack) then
 	 			fclose (fs_searchpaths->pack->handle) 
				Z_Free (fs_searchpaths->pack->_files) 
				Z_Free (fs_searchpaths->pack)
			
			
	 
 	 		End If
 	 		
 	 	_next = fs_searchpaths->_next 
		Z_Free (fs_searchpaths) 
		fs_searchpaths = _next 
 	
 	 	Wend

	'//
	'// flush all data, so it will be forced to reload
	'//
	if (dedicated <> NULL and  dedicated->value <> NULL) then
				Cbuf_AddText (!"vid_restart\nsnd_restart\n") 
	End If
 

  Com_sprintf (_fs_gamedir, sizeof(_fs_gamedir), !"%s/%s", fs_basedir->_string, _dir) 

	 if (strcmp(_dir,BASEDIRNAME) = 0 or (*_dir = 0)) then
 
	 Cvar_FullSet (!"gamedir", "", _CVAR_SERVERINFO or CVAR_NOSET) 
 	Cvar_FullSet (!"game", "", CVAR_LATCH or _CVAR_SERVERINFO) 
 
	  else
 
	 Cvar_FullSet (!"gamedir", _dir, _CVAR_SERVERINFO or CVAR_NOSET) 
	 	if (fs_cddir->_string[0]) then
		FS_AddGameDirectory (_va(!"%s/%s", fs_cddir->_string, _dir) ) 
		FS_AddGameDirectory (_va(!"%s/%s", fs_basedir->_string, _dir) ) 
	
		end if
	 End If

	
	
End Sub

 	 
	
	
