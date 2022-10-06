'/*
'Copyright (C) 1997-2001 Id Software, Inc.
'
'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
'
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
'
'*/
'
'//
'// console
'//

#define	NUM_CON_TIMES 4

#define		CON_TEXTSIZE	32768
type console_t
	as qboolean	initialized 
	as zstring * CON_TEXTSIZE	text  
	as integer 		current 		'// line where next message will be printed
	as integer		x  			'// offset in current line for next print
	as integer		display 		'// bottom of console displays this line

	as integer		ormask 			'// high bit mask for colored characters

	as integer 	linewidth 		'// characters across screen
	as integer		totallines 		'// total lines in console scrollback

	as float	cursorspeed 

	as integer		vislines 

	as float	times(NUM_CON_TIMES) 	'// cls.realtime time the line was generated
								'// for transparent notify lines
 
	
End Type
 


extern as console_t	con 

declare sub Con_DrawCharacter (cx as integer ,integerline as  integer  ,num as  integer ) 

declare sub Con_CheckResize ()
declare sub Con_Init ()
declare sub Con_DrawConsole (_frac as float )
'declare sub Con_Print (txt as zstring ptr) 
declare sub Con_CenteredPrint (text as zstring ptr)
declare sub Con_Clear_f ()
declare sub Con_DrawNotify ()
declare sub Con_ClearNotify ()
declare sub Con_ToggleConsole_f ()
