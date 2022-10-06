' WORK IN PROGRESS''''''''''''''''''''''''''''''''''''
 

#Include "Game\qshared.bi"








dim shared as zstring * MAX_TOKEN_CHARS	com_token  




'/*
'============
'COM_FilePath
'
'Returns the path up to, but not including the last /
'============
'*/
sub COM_FilePath (_in as zstring ptr, _out  as zstring ptr)
	dim as	zstring ptr s
	
	s = _in + strlen(_in) - 1 
	
	while (s <> _in and *s <> asc("/"))
		s-=1	
	Wend
 

	strncpy (_out,_in, s-_in) 
	_out[s-_in] = 0 
	
	
End Sub
 





'/*
'==============
'COM_Parse
'
'Parse a token out of a string
'==============
'*/
function COM_Parse (data_p as zstring ptr ptr) as zstring ptr
 
	dim  as  integer		c 
	dim  as  integer		_len 
   dim  as zstring  ptr _data 


  



	_data = *data_p
	
	
  'print "in COM_Parse"
  '
  '
  'print *_data
  'sleep
 'print *_data 
 'sleep


	 
	_len = 0 
	com_token[0] = 0 
	
	if (_data = null) then
	 
		*data_p = NULL 
		return @"" 
	end if
		


	
'// skip whitespace
skipwhite:
 c = *_data 
	while ( c <= asc(" "))

		
		if (c = 0) then
		 
			*data_p = NULL 
			return @"" 
		end if
		_data+=1
	wend

'// skip // comments
	if (c= asc("/") and _data[1] = asc("/")) then
		 while (*_data and *_data <> asc(!"\n"))
		 		_data+=1
		 Wend
		
		goto skipwhite 
		
	EndIf
 
 
 

	
'// handle quoted strings specially
 	if (c =  asc(!"\"")) then
 	_data+=1 
 		while (1)
         
    		c = *_data:_data+=1 
    		
    		if (c = asc(!"\"") or  c = NULL) then
    		
 
 			    com_token[_len] = 0 
 				*data_p = _data 
 				return @com_token 
    		
        end if
 			if (_len < MAX_TOKEN_CHARS) then
 				com_token[_len] = c
 				_len+=1
 			EndIf
 
 		wend
end if




'// parse a regular word
	do
	 
		if (_len < MAX_TOKEN_CHARS) then
		 com_token[_len] = c 
			_len+=1 
		 end if
		_data+=1
		c = *_data
			
			

 
	loop while (c>32) 
 
	
	
	
	if (_len =  MAX_TOKEN_CHARS) then
	 
'//		Com_Printf ("Token exceeded %i chars, discarded.\n", MAX_TOKEN_CHARS);
		_len = 0 
	end if
	com_token[_len] = 0 

	*data_p = _data 
	return @com_token 
end function



'/*
'============================================================================
'
'					BYTE ORDER FUNCTIONS
'
'============================================================================
'*/

dim shared 	bigendien as qboolean

dim shared  _BigShort as function(l as short )as short
dim shared  _LittleShort as function(l as short )as short
dim shared  _BigLong as function(l as integer )as integer
dim shared  _LittleLong as function(l as integer )as integer
dim shared  _BigFloat as function(l as float )as float
dim shared  _LittleFloat as function(l as float )as float




sub Com_sprintf cdecl (dest as ZString ptr, _size as integer ,fmt  as ZString ptr, ...)
	
	 
	dim _len  as integer		
	dim argptr as va_list 
	 dim  bigbuffer as ZString * &H10000

	cva_start (argptr,fmt) 
	_len = vsprintf (bigbuffer,fmt,argptr) 
	cva_end (argptr) 
	if (_len >= _size) then
				'Com_Printf ("Com_sprintf: overflow of %i in %i\n", len, size) 
		printf(!"Com_sprintf: overflow of %i in %i\n", _len, _size)
	EndIf

	strncpy (dest, bigbuffer, _size-1) 
 

	
End Sub










'/*
'============
'va
'
'does a varargs printf into a temp buffer, so I don't need to have
'varargs versions of all text functions.
'FIXME: make this buffer size safe someday
'============
'*/

'ptr
function _va cdecl(_format  as ZString ptr, ...) as ZString ptr
	dim argptr as	va_list		 
	static  	_string as ZString *1024
	
	cva_start (argptr, _format) 
	vsprintf (_string, _format,argptr) 
	cva_end (argptr) 

	return @_string 	
End Function
 

 


function BigLong(l as integer) as integer
	return _BigLong(l)
	
End Function

function LittleLong(l as integer) as integer
	return _LittleLong(l)
	
End Function

function BigFloat(l as float) as float
	return _BigFloat(l)
	
End Function

function LittleFloat(l as Float) as Float
	return _LittleFloat(l)
	
End Function




function LittleShort(l as short) as short
	return _LittleShort(l)
	
End Function

function BigShort(l as short) as short
	return _BigShort(l)
End Function



function	ShortNoSwap (l as short ) as  short
	return l
End Function


 
 function ShortSwap (l as short ) as short  
 	dim as ubyte    b1,b2 

	b1 = l and 255 
	b2 = (l shr 8) and 255 
	return (b1 shl 8) + b2 
 
 	
 End Function
 
 function	FloatNoSwap (l as float ) as  float
	return l
End Function


 
 function FloatSwap (f as Float ) as Float 
 	 
 	union _f
 		f as float 
		b(4) as ubyte	
 	End Union: dim as _f dat1,dat2
	 
	dat1.f = f
	dat2.b(0) = dat1.b(3)
	dat2.b(1) = dat1.b(2)
	dat2.b(2) = dat1.b(1)
	dat2.b(3) = dat1.b(0)
	return dat2.f 

 End Function
 
 
 function Q_stricmp (s1 as zstring ptr, s2 as zstring ptr) as integer
 	
 #if defined(__FB_WIN32__)
	return _stricmp (s1, s2) 
#else
	return strcasecmp (s1, s2) 
#endif
 
 	
 	
 End Function
  

 
 
  function LongSwap ( l as integer) as integer 
  dim	as ubyte    b1,b2,b3,b4 

	b1 = l and 255 
	b2 = (l shr 8) and 255 
	b3 = (l shr 16)and 255 
	b4 = (l shr 24) and 255 

	return (cast(integer,b1)shl 24) + (cast(integer,b2) shl 16) + (cast(integer,b3) shl 8)  + b4 


  	
  End Function
 


function LongNoSwap ( l as integer) as integer
	
		return l 
	
End Function



'/*
'================
'Swap_Init
'================
'*/


sub Swap_Init ()
  
	dim	swaptest(2) as UByte => {1,0} 

'// set the byte swapping variables in a portable manner	
	if ( *cast(short ptr, @swaptest(0))  = 1) then
	 
		 bigendien = _false 
		 _BigShort = @ShortSwap 
		 _LittleShort = @ShortNoSwap 
		 _BigLong = @LongSwap 
		 _LittleLong = @LongNoSwap 
		 _BigFloat = @FloatSwap 
		 _LittleFloat = @FloatNoSwap 
 
	else
 
		 bigendien = _true 
		 _BigShort = @ShortNoSwap 
		 _LittleShort = @ShortSwap 
		 _BigLong = @LongNoSwap 
		 _LittleLong = @LongSwap 
	    _BigFloat = @FloatNoSwap 
		 _LittleFloat = @FloatSwap 
 
	end if
end sub





	

 

	
 







'short	(*_LittleShort) (short l);
'int		(*_BigLong) (int l);
'int		(*_LittleLong) (int l);
'float	(*_BigFloat) (float l);
'float	(*_LittleFloat) (float l);

'short	BigShort(short l){return _BigShort(l);}
'short	LittleShort(short l) {return _LittleShort(l);}
'int		BigLong (int l) {return _BigLong(l);}
'int		LittleLong (int l) {return _LittleLong(l);}
'float	BigFloat (float l) {return _BigFloat(l);}
'float	LittleFloat (float l) {return _LittleFloat(l);}


'WORKS FINE''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 function Q_strncasecmp (s1 as zstring ptr,s2 as zstring ptr,n as  integer ) as Integer
 
	dim as integer		c1, c2 
	
	do
	 
		c1 = *s1:s1+=1 
		c2 = *s2:s2+=1
    
    
 	


		if (n = 0) then
			return 0 		'// strings are equal until end point
		EndIf
		n-=1	
		
		if (c1 <> c2) then
		 
			if (c1 >= asc("a")  and c1 <= asc("z")) then
				c1 -= (asc("a") - asc("A"))
			end if
			if (c2 >= asc("a") and c2 <= asc("z")) then
				c2 -= (asc("a") - asc("A"))
			end if
			if (c1 <> c2) then
				return -1 		'// strings not equal
			
			end if
			
		 end if
	  loop while  c1  

	return 0 		'// strings are equal
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function Q_strcasecmp ( s1 as zstring ptr,s2 as zstring ptr) as integer
		return Q_strncasecmp (s1, s2, 99999) 
	
End Function
 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

sub R_ConcatTransforms (in1() as float,in2() as float,_out() as float) 
 
	_out(0,0) = in1(0,0) * in2(0,0) + in1(0,1) * in2(1,0) + _
				in1(0,2) * in2(2,0) 
	_out(0,1) = in1(0,0) * in2(0,1) + in1(0,1) * in2(1,1) + _
				in1(0,2) * in2(2,1) 
	_out(0,2) = in1(0,0) * in2(0,2) + in1(0,1) * in2(1,2) + _
				in1(0,2) * in2(2,2) 
	_out(1,0) = in1(1,0) * in2(0,0) + in1(1,1) * in2(1,0) + _
				in1(1,2) * in2(2,0) 
	_out(1,1) = in1(1,0) * in2(0,1) + in1(1,1) * in2(1,1) + _
				in1(1,2) * in2(2,1) 
	_out(1,2) = in1(1,0) * in2(0,2) + in1(1,1) * in2(1,2) + _
				in1(1,2) * in2(2,2) 
	_out(2,0) = in1(2,0) * in2(0,0) + in1(2,1) * in2(1,0) + _
				in1(2,2) * in2(2,0) 
	_out(2,1) = in1(2,0) * in2(0,1) + in1(2,1) * in2(1,1) + _
				in1(2,2) * in2(2,1) 
	_out(2,2) = in1(2,0) * in2(0,2) + in1(2,1) * in2(1,2) + _
				in1(2,2) * in2(2,2) 
end sub