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
#ifndef __QMENU_H__
#define __QMENU_H__

#define MAXMENUITEMS	64

#define MTYPE_SLIDER		0
#define MTYPE_LIST			1
#define MTYPE_ACTION		2
#define MTYPE_SPINCONTROL	3
#define MTYPE_SEPARATOR  	4
#define MTYPE_FIELD			5

#define	K_TAB			9
#define	K_ENTER			13
#define	K_ESCAPE		27
#define	K_SPACE			32

'// normal keys should be passed as lowercased ascii

#define	K_BACKSPACE		127
#define	K_UPARROW		128
#define	K_DOWNARROW		129
#define	K_LEFTARROW		130
#define	K_RIGHTARROW	131

#define QMF_LEFT_JUSTIFY	&H00000001
#define QMF_GRAYED			&H00000002
#define QMF_NUMBERSONLY		&H00000004




#endif






