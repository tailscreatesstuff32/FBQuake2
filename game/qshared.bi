''MIGHT BE INISHED FOR NOOW EXCEPT SOME ISSUES'''''''''''''''''''''''''''''''

 '#include "windows.bi"

 #define id386	1

  'not sure'''''''''''''''''''''''''''''''
 'type image_t as image_s
 'type edict_s as edict_s
  '''''''''''''''''''''''''''''''

 



#ifdef __FB_WIN32__

'#pragma warning(disable : 4244)     
'#pragma warning(disable : 4136)  
'#pragma warning(disable : 4051)     
'
'#pragma warning(disable : 4018)      
'#pragma warning(disable : 4305)		 

#endif

'might not need'''''''''
'#include "crt/assert.bi"
''''''''''''''''''''
'#include "crt\math.bi"
'#include "crt\stdio.bi"
'#include "crt\stdarg.bi"
'#include "crt\string.bi"
'#include "crt\stdlib.bi"
'
#include "crt\time.bi"
#include "crt.bi"


type cplane_s as _cplane_s

enum qboolean
   _false
	_true
End enum
'''''''''''''''''''''''''''''''

#define	PITCH				0		
#define	YAW				1		
#define	ROLL				2		

#define	MAX_STRING_CHARS	1024	
#define	MAX_STRING_TOKENS	80		
#define	MAX_TOKEN_CHARS		128		

#define	MAX_QPATH			64		
#define	MAX_OSPATH			128		


#define	MAX_CLIENTS			256		
#define	MAX_EDICTS			1024	
#define	MAX_LIGHTSTYLES		256
#define	MAX_MODELS			256		
#define	MAX_SOUNDS			256		
#define	MAX_IMAGES			256
#define	MAX_ITEMS			256
#define MAX_GENERAL			(MAX_CLIENTS*2)	



#define	PRINT_LOW			0	
#define	PRINT_MEDIUM		1		
#define	PRINT_HIGH			2		
#define	PRINT_CHAT			3	



#define	ERR_FATAL			0		 
#define	ERR_DROP			1		 
#define	ERR_DISCONNECT		2		 

#define	PRINT_ALL			0
#define PRINT_DEVELOPER		1		 
#define PRINT_ALERT			2		



enum multicast_t
MULTICAST_ALL,
MULTICAST_PHS,
MULTICAST_PVS,
MULTICAST_ALL_R,
MULTICAST_PHS_R,
MULTICAST_PVS_R
End Enum
 

 'not sure'''''''''''''''''''''' 
type  vec_t as float
' type  vec_tp as float ptr
 
 'type vec3_t
 '	x as float
 '	y as float
 '	z as float
 'End Type

 'type vec3_t2
	
	'v(3) as float
	
 'End Type
 
 type vec3_t
	
	v(3) as float
	
 End Type
 
 type vec5_t
	
	v(5) as float
	
 End Type



'type  vec3_t as vec_t        '[3] 
'type  vec5_t  as vec_t       '[5] 
 '''''''''''''''''''''''''''''''
'type vec3_t:v00 as float:v01 as float:v02 as float:End Type
'type vec5_t:v00 as float:v01 as float:v02 as float:v03 as float:v04 as float:End Type
 
type 	fixed4_t as	integer
type 	fixed8_t  as	integer
type 	fixed16_t  as	integer	

#ifndef M_PI
#define M_PI		3.14159265358979323846	 
#endif

 'not sure''''''''''''''''''''''
'type cplane_s as any
 '''''''''''''''''''''''''''''''
 
 
 
 
 #define	nanmask (255 shl 23)
 
 
 
 
extern vec3_origin as vec3_t 
 
 
 
 
 #if not(defined(C_ONLY)) and not(defined( __linux__)) and  not(defined(__sgi))
 ' see if i ts fine for now
	'extern "C"
		declare  function Q_ftol naked (f as float  ) as long 
	'end extern
	#else
	 #define Q_ftol( f ) cast(long,f)
 #endif
 
'#define DotProduct(x,y)			(x(0)*y(0)+x(1)*y(1)+x(2)*y(2))
'#define DotProduct(x,y)			(x.v00*y.v00+x.v01*y.v01+x.v02*y.v02)
'#define DotProduct(x,y)			(x[0]*y[0]+x[1]*y[1]+x[2]*y[2])
'#define DotProduct(x1,y1)			(x1.x*y1(0,0)+x1.y*y1(1,0)+x1.z*y1(2,0))

'#define DotProduct2(x1,y1)			(x1[0]*y1[0]+x1[1]*y1[1]+x1[2]*y1[2])
'
'#define DotProduct3(x1,y1)			(x1->v(0)*y1->v(0)+x1->v(1)*y1->v(1)+x1->v(2)*y1->v(2))



'MIGHT WORK///////////////////////////////////////////////
'#define DotProduct(x,y)			(cast(float ptr, x)[0]*cast(float ptr, y)[0]+cast(float ptr, x)[1]*cast(float ptr, y)[1]+cast(float ptr, x)[2]*cast(float ptr, y)[2])
 #define DotProduct(x,y)			(cast(float ptr, x)[0]*cast(float ptr, y)[0]+cast(float ptr, x)[1]*cast(float ptr, y)[1]+cast(float ptr, x)[2]*cast(float ptr, y)[2])

'/////////////////////////////////////////////////////////

#define VectorSubtract(a,b,c)	(c(0)=a(0)-b(0),c(1)=a(1)-b(1),c(2)=a(2)-b(2))
#define VectorAdd(a,b,c)		(c(0)=a(0)+b(0),c(1)=a(1)+b(1),c(2)=a(2)+b(2))
#define VectorCopy(a,b)			(b(0)=a(0),b(1)=a(1),b(2)=a(2))
#define VectorClear(a)			(a(0)=a(1)=a(2)=0)
#define VectorNegate(a,b)		(b(0)=-a(0),b(1)=-a(1),b(2)=-a(2))
#define VectorSet(v, x, y, z)	(v(0)=(x), v(1)=(y), v(2)=(z))
 
declare sub VectorMA (veca as vec3_t ptr ,_scale as float , vecb as vec3_t ptr, vecc  as vec3_t ptr) 
 
 
declare function _DotProduct (v1 as vec3_t ptr, v2 as vec3_t ptr) As vec_t 
declare sub   _VectorSubtract (veca as vec3_t ptr, vecb as vec3_t ptr, _out as vec3_t ptr)
declare sub   _VectorAdd (veca as vec3_t ptr,vecb as vec3_t ptr,_out as vec3_t ptr)
declare sub   _VectorCopy ( _in as vec3_t ptr,  _out as vec3_t ptr)
 
declare sub   ClearBounds (mins as vec3_t ptr , maxs as vec3_t ptr)
declare sub  AddPointToBounds (v as vec3_t ptr, mins as  vec3_t ptr , maxs as vec3_t ptr)
declare function VectorCompare (v1 as vec3_t ptr ,v2 as vec3_t ptr) as integer 
declare function VectorLength (_v as vec3_t ptr) as vec_t 
declare sub CrossProduct ( v1 as vec3_t ptr, v2 as vec3_t ptr,cross as vec3_t ptr ) 
declare function VectorNormalize ( _v  as vec3_t ptr) as vec_t 
declare function VectorNormalize2 (_v as vec3_t ptr ,_out as vec3_t  ptr ) as vec_t 
declare sub VectorInverse ( _v as vec3_t ptr) 

'declare sub VectorScale (_in() as vec3_t , _scale as  vec_t,_out() as vec3_t )
declare sub VectorScale (_in  as vec3_t ptr , scale as  vec_t ,_out  as vec3_t ptr  )

declare function Q_log2(_val as integer ) as integer 

 



'MIGHT WORK///////////////////////////////////////////
 declare sub  R_ConcatRotations (in1()  as float,in2() as float,_out() as float)
declare sub  R_ConcatTransforms (in1() as float,in2() as float,_out() as float)
'/////////////////////////////////////////////////





 declare sub AngleVectors (angles as vec3_t ptr,forward as vec3_t ptr ,_right as vec3_t ptr ,_up as  vec3_t ptr) 
 'declare sub AngleVectors (angles as vec_tp , forward as vec_tp, _right as vec_tp ,up as vec_tp)
 	
 	
 
'not sure''''''''''''''''''''''''''''''''
 'declare function BoxOnPlaneSide naked  ( emins as vec3_t, emaxs as vec3_t, _plane as cplane_s ptr) as integer 
'''''''''''''''''''''''''''''''''''''''''
'temp
 declare function BoxOnPlaneSide (emins as vec3_t ptr, emaxs as vec3_t ptr, p as cplane_s ptr) as integer 
''''''''''''''''''''''''''''''''''''''''''''''

declare function _BOX_ON_PLANE_SIDE(emins as vec3_t ptr, emaxs as vec3_t ptr, p as cplane_s ptr) as integer
#define BOX_ON_PLANE_SIDE(emins, emaxs, p) _
			iif((p)->_type < 3,_
					iif((p)->dist <= (emins)->v((p)->_type), _
						1, _
						iif( (p)->dist <= (emaxs)->v((p)->_type), _
							2, _
							3 _
						) _	
					), _		 
	      BoxOnPlaneSide(emins,emaxs,p))
					

 



declare function anglemod(a as float ) as  float	
declare function LerpAngle (a1 as float ,a2 as float ,_frac as float ) as float 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'not sure if fixed

'#define BOX_ON_PLANE_SIDE(emins, emaxs, p) (((p)->type < 3)?(((p)->dist <= (emins)[(p)->type])?1:(((p)->dist >= (emaxs)[(p)->type])?2:3)):BoxOnPlaneSide( (emins), (emaxs), (p)))
'#define BOX_ON_PLANE_SIDE(emins, emaxs, p) iif((p)->_type < 3,(iif((p)->dist <= ((emins)->v(((p)->_type)),1,iif((p)->dist >= ((emaxs)->v((p)->_type)),2,3))),BoxOnPlaneSide( (emins), (emaxs), (p)))	
''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'declare sub ProjectPointOnPlane( dst() as vec3_t , p() as  const  vec3_t, _normal() as const  vec3_t ) 
'declare sub ProjectPointOnPlane( dst as vec_tp , p as const vec_tp , normal as const vec_tp  )
declare sub ProjectPointOnPlane( dst as vec3_t ptr, p as const vec3_t ptr, normal as const vec3_t ptr )



'declare sub PerpendicularVector( dst() as vec3_t ,src() as  const  vec3_t) 
declare sub PerpendicularVector( dst as vec3_t ptr,src as  const  vec3_t ptr) 

'declare sub RotatePointAroundVector( dst() as vec3_t, _dir() as vec3_t,  _point() as const vec3_t, degrees as float) 
'declare sub RotatePointAroundVector( dst  as vec_tp, _dir  as vec_tp,  _point  as const vec_tp, degrees as float) 

declare sub RotatePointAroundVector( dst  as vec3_t ptr, _dir  as vec3_t ptr,  _point  as const vec3_t ptr, degrees as float) 



declare function  COM_SkipPath (pathname as zstring ptr)  as ZString ptr
declare sub StripExtension (_in  as zstring ptr, _out as zstring ptr) 
declare sub COM_FileBase (_in  as zstring ptr, _out as zstring ptr) 
declare sub COM_FilePath (_in  as zstring ptr, _out as zstring ptr) 
declare sub COM_DefaultExtension (path  as zstring ptr ,extension as zstring ptr ) 

declare function COM_Parse  (data_p  as zstring ptr ptr) as zstring ptr

declare sub Com_sprintf cdecl (dest as ZString ptr, _size as integer ,fmt  as ZString ptr, ...) 
declare sub Com_PageInMemory (buffer as ubyte ptr ,_size as integer ) 
  
declare function Q_stricmp (s1 as zstring ptr,s2 as zstring ptr) as integer  
declare function Q_strcasecmp (s1 as zstring ptr,s2 as zstring ptr) as integer
declare function Q_strncasecmp (s1 as zstring ptr,s2 as zstring ptr,n as integer) as integer

declare function  BigShort( l as short) as short
declare function LittleShort( l as short) as short
declare function BigLong ( l as integer) as integer 
declare function LittleLong ( l as integer) as integer   
declare function  BigFloat( l as float) as float
declare function  LittleFloat( l as float) as float

declare sub	Swap_Init ()
declare function _va cdecl(_format as zstring ptr, ...) as zstring ptr

#define	MAX_INFO_KEY		64
#define	MAX_INFO_VALUE		64
#define	MAX_INFO_STRING	512
 
declare function Info_ValueForKey (s as ZString ptr,key  as ZString ptr) as ZString ptr
declare sub Info_RemoveKey (s  as ZString ptr, _key  as ZString ptr) 
declare sub Info_SetValueForKey (s  as ZString ptr,_key  as ZString ptr, value  as ZString ptr) 
declare function Info_Validate (s  as ZString ptr) as qboolean 

extern	curtime as integer	

declare function Sys_Milliseconds () as Integer
declare sub	Sys_Mkdir (path as ZString ptr) 
 
'declare sub Hunk_Begin  (maxsize as integer) 
'declare sub Hunk_Alloc  (_size as integer ) 
'declare sub Hunk_Free   (buf as any ptr) 
'declare function   Hunk_End  () as Integer

declare function Hunk_Begin  (maxsize as integer)  as any ptr
declare function Hunk_Alloc  (_size as integer ) as any ptr
declare sub Hunk_Free   (buf as any ptr) 
declare function   Hunk_End  () as Integer





 #define SFF_ARCH    &H01
#define SFF_HIDDEN  &H02
#define SFF_RDONLY  &H04
#define SFF_SUBDIR  &H08
#define SFF_SYSTEM  &H10
 
 
 
declare function Sys_FindFirst (_path as zstring ptr, musthave as UInteger,canthave as  uinteger  ) as zstring ptr
declare function cSys_FindNext ( musthave as UInteger,canthave as  uinteger  ) as zstring ptr
declare sub Sys_FindClose () 
 
 'declare sub Com_Printf CDecl (fmt as zstring ptr,...)
'declare sub sys_error CDecl (_error as zstring ptr,...)
 
 
#ifndef CVAR
#define	CVAR

#define	CVAR_ARCHIVE	1	
#define	_CVAR_USERINFO	2	 
#define	_CVAR_SERVERINFO	4	 
#define	CVAR_NOSET		8	 
						 
#define	CVAR_LATCH		16	 
 
 
 
 
 
 
 type  cvar_s
 
	_name as zstring ptr
	_string as zstring ptr
	latched_string as zstring ptr
	flags as integer			
	modified as qboolean	 
	value as float		
	_next as cvar_s ptr
end type:type cvar_t as cvar_s


 
 #endif
 


  
 
 
#define	CONTENTS_SOLID			1		 
#define	CONTENTS_WINDOW			2		 
#define	CONTENTS_AUX			4
#define	CONTENTS_LAVA			8
#define	CONTENTS_SLIME			16
#define	CONTENTS_WATER			32
#define	CONTENTS_MIST			64
#define	LAST_VISIBLE_CONTENTS	64

 

#define	CONTENTS_AREAPORTAL		&H8000

#define	CONTENTS_PLAYERCLIP		&H10000
#define	CONTENTS_MONSTERCLIP	&H20000

 
#define	CONTENTS_CURRENT_0		&H40000
#define	CONTENTS_CURRENT_90		&H80000
#define	CONTENTS_CURRENT_180	&H100000
#define	CONTENTS_CURRENT_270	&H200000
#define	CONTENTS_CURRENT_UP		&H400000
#define	CONTENTS_CURRENT_DOWN	&H800000

'#define	CONTENTS_ORIGIN			&H100000 

#define	CONTENTS_MONSTER		&H2000000	 
#define	CONTENTS_DEADMONSTER	&H4000000
#define	CONTENTS_DETAIL			&H8000000	 
#define	CONTENTS_TRANSLUCENT	&H10000000	 
#define	CONTENTS_LADDER			&H20000000



#define	SURF_LIGHT		&H1		 

#define	SURF_SLICK		&H2		 

#define	SURF_SKY		&H4		 
#define	SURF_WARP		&H8		 
#define	SURF_TRANS33	&H10
#define	SURF_TRANS66	&H20
#define	SURF_FLOWING	&H40	 
#define	SURF_NODRAW		&H80	 



 
 
#define	MASK_ALL				(-1)
#define	MASK_SOLID				(CONTENTS_SOLID or CONTENTS_WINDOW)
#define	MASK_PLAYERSOLID		(CONTENTS_SOLID or CONTENTS_PLAYERCLIP or CONTENTS_WINDOW or CONTENTS_MONSTER)
#define	MASK_DEADSOLID			(CONTENTS_SOLID or CONTENTS_PLAYERCLIP or CONTENTS_WINDOW)
#define	MASK_MONSTERSOLID		(CONTENTS_SOLID or CONTENTS_MONSTERCLIP or CONTENTS_WINDOW or CONTENTS_MONSTER)
#define	MASK_WATER				(CONTENTS_WATER or CONTENTS_LAVA or CONTENTS_SLIME)
#define	MASK_OPAQUE				(CONTENTS_SOLID or CONTENTS_SLIME or CONTENTS_LAVA)
#define	MASK_SHOT				(CONTENTS_SOLID  or  CONTENTS_MONSTER or CONTENTS_WINDOW  or  CONTENTS_DEADMONSTER)
#define  MASK_CURRENT			(CONTENTS_CURRENT_0  or CONTENTS_CURRENT_90 or CONTENTS_CURRENT_180 or CONTENTS_CURRENT_270 or CONTENTS_CURRENT_UP or CONTENTS_CURRENT_DOWN)


 
 

#define	AREA_SOLID		1
#define	AREA_TRIGGERS	2


 
 

  type _cplane_s
  _normal as vec3_t
	dist as float
	_type as ubyte
	signbits as ubyte
	
	
  End Type: type cplane_t as cplane_s


#define CPLANE_NORMAL_X			0
#define CPLANE_NORMAL_Y			4
#define CPLANE_NORMAL_Z			8
#define CPLANE_DIST				12
#define CPLANE_TYPE				16
#define CPLANE_SIGNBITS			17
#define CPLANE_PAD0				18
#define CPLANE_PAD1				19


type cmodel_s
	as vec3_t mins, maxs 
	origin  as vec3_t		
	headnode as integer	
	
End Type:type cmodel_t as cmodel_s
 
		
  

type surface_s
 
	 _name as zstring * 16 
	flags as Integer
	 value  as Integer
End Type:type csurface_t as surface_s

type mapsurface_s  
 
	c  as csurface_t	
 rname as ZString *32 
End Type:type mapsurface_t as  mapsurface_s 

type trace_t

	allsolid as qboolean		 
	startsolid as qboolean	
   fraction	as float		 
		endpos as vec3_t		 
	 plane 	as cplane_t 
	  surface as csurface_t ptr		 
		contents  as integer			 
	 ' _ent as edict_s ptr
end type
 

 
 
 enum pmtype_t
	PM_NORMAL,
	PM_SPECTATOR,
	PM_DEAD,
	PM_GIB,
	PM_FREEZE
End Enum

#define	PMF_DUCKED			1
#define	PMF_JUMP_HELD		2
#define	PMF_ON_GROUND		4
#define	PMF_TIME_WATERJUMP	8	
#define	PMF_TIME_LAND		16	
#define	PMF_TIME_TELEPORT	32	
#define PMF_NO_PREDICTION	64	



type pmove_state_t
	
	pm_type as 	pmtype_t	

	origin(3)  as short 
	velocity(3)	as short		 
	pm_flags as ubyte			 
	pm_time	as ubyte	  
	gravity as short		 
   delta_angles(3)	as short		 
									 
End Type

 
 
 
 #define	BUTTON_ATTACK		1
#define	BUTTON_USE			2
#define	BUTTON_ANY			128




 
type  usercmd_s
 
	msec as ubyte	
	buttons as ubyte
   angles(3) as short	
	as short	forwardmove, sidemove, upmove 
	impulse as ubyte	 
   lightlevel as	ubyte	
end type:type usercmd_t as usercmd_s
 
 
 

 #define	MAXTOUCH	32
 
 
 
 type pmove_t
  
	s  as pmove_state_t	
 
	cmd  as usercmd_t		
   snapinitial	as qboolean		 

 
	numtouch as Integer			
 

		viewangles as vec3_t	
		viewheight as float	

	as vec3_t		mins, maxs 

 
	watertype as Integer			
	waterlevel as Integer				

 
	 _trace as function ( _start  as vec3_t, mins as vec3_t , maxs as vec3_t,_end as vec3_t ) as trace_t	
	 pointcontents as function( _point as vec3_t) as Integer
 end type

 

 
 #define	EF_ROTATE			&H00000001		
#define	EF_GIB				&H00000002		
#define	EF_BLASTER			&H00000008		
#define	EF_ROCKET			&H00000010		
#define	EF_GRENADE			&H00000020
#define	EF_HYPERBLASTER		&H00000040
#define	EF_BFG				&H00000080
#define EF_COLOR_SHELL		&H00000100
#define EF_POWERSCREEN		&H00000200
#define	EF_ANIM01			&H00000400		
#define	EF_ANIM23			&H00000800	
#define EF_ANIM_ALL			&H00001000	
#define EF_ANIM_ALLFAST		&H00002000	
#define	EF_FLIES			&H00004000
#define	EF_QUAD				&H00008000
#define	EF_PENT				&H00010000
#define	EF_TELEPORTER		&H00020000	
#define EF_FLAG1			&H00040000
#define EF_FLAG2			&H00080000

#define EF_IONRIPPER		&H00100000
#define EF_GREENGIB			&H00200000
#define	EF_BLUEHYPERBLASTER &H00400000
#define EF_SPINNINGLIGHTS	&H00800000
#define EF_PLASMA			&H01000000
#define EF_TRAP				&H02000000


#define EF_TRACKER			&H04000000
#define	EF_DOUBLE			&H08000000
#define	EF_SPHERETRANS		&H10000000
#define EF_TAGTRAIL			&H20000000
#define EF_HALF_DAMAGE		&H40000000
#define EF_TRACKERTRAIL		&H80000000

#define	RF_MINLIGHT			1	
#define	RF_VIEWERMODEL		2		
#define	RF_WEAPONMODEL		4		
#define	RF_FULLBRIGHT		8		
#define	RF_DEPTHHACK		16		
#define	RF_TRANSLUCENT		32
#define	RF_FRAMELERP		64
#define RF_BEAM				128
#define	RF_CUSTOMSKIN		256		
#define	RF_GLOW				512		
#define RF_SHELL_RED		1024
#define	RF_SHELL_GREEN		2048
#define RF_SHELL_BLUE		4096


#define RF_IR_VISIBLE		&H00008000		
#define	RF_SHELL_DOUBLE		&H00010000		
#define	RF_SHELL_HALF_DAM	&H00020000
#define RF_USE_DISGUISE		&H00040000


#define	RDF_UNDERWATER		1		
#define RDF_NOWORLDMODEL	2		


#define	RDF_IRGOGGLES		4
#define RDF_UVGOGGLES		8


#define	MZ_BLASTER			0
#define MZ_MACHINEGUN		1
#define	MZ_SHOTGUN			2
#define	MZ_CHAINGUN1		3
#define	MZ_CHAINGUN2		4
#define	MZ_CHAINGUN3		5
#define	MZ_RAILGUN			6
#define	MZ_ROCKET			7
#define	MZ_GRENADE			8
#define	MZ_LOGIN			9
#define	MZ_LOGOUT			10
#define	MZ_RESPAWN			11
#define	MZ_BFG				12
#define	MZ_SSHOTGUN			13
#define	MZ_HYPERBLASTER		14
#define	MZ_ITEMRESPAWN		15

#define MZ_IONRIPPER		16
#define MZ_BLUEHYPERBLASTER 17
#define MZ_PHALANX			18
#define MZ_SILENCED			128 


#define MZ_ETF_RIFLE		30
#define MZ_UNUSED			31
#define MZ_SHOTGUN2			32
#define MZ_HEATBEAM			33
#define MZ_BLASTER2			34
#define	MZ_TRACKER			35
#define	MZ_NUKE1			36
#define	MZ_NUKE2			37
#define	MZ_NUKE4			38
#define	MZ_NUKE8			39

#define MZ2_TANK_BLASTER_1				1
#define MZ2_TANK_BLASTER_2				2
#define MZ2_TANK_BLASTER_3				3
#define MZ2_TANK_MACHINEGUN_1			4
#define MZ2_TANK_MACHINEGUN_2			5
#define MZ2_TANK_MACHINEGUN_3			6
#define MZ2_TANK_MACHINEGUN_4			7
#define MZ2_TANK_MACHINEGUN_5			8
#define MZ2_TANK_MACHINEGUN_6			9
#define MZ2_TANK_MACHINEGUN_7			10
#define MZ2_TANK_MACHINEGUN_8			11
#define MZ2_TANK_MACHINEGUN_9			12
#define MZ2_TANK_MACHINEGUN_10			13
#define MZ2_TANK_MACHINEGUN_11			14
#define MZ2_TANK_MACHINEGUN_12			15
#define MZ2_TANK_MACHINEGUN_13			16
#define MZ2_TANK_MACHINEGUN_14			17
#define MZ2_TANK_MACHINEGUN_15			18
#define MZ2_TANK_MACHINEGUN_16			19
#define MZ2_TANK_MACHINEGUN_17			20
#define MZ2_TANK_MACHINEGUN_18			21
#define MZ2_TANK_MACHINEGUN_19			22
#define MZ2_TANK_ROCKET_1				23
#define MZ2_TANK_ROCKET_2				24
#define MZ2_TANK_ROCKET_3				25

#define MZ2_INFANTRY_MACHINEGUN_1		26
#define MZ2_INFANTRY_MACHINEGUN_2		27
#define MZ2_INFANTRY_MACHINEGUN_3		28
#define MZ2_INFANTRY_MACHINEGUN_4		29
#define MZ2_INFANTRY_MACHINEGUN_5		30
#define MZ2_INFANTRY_MACHINEGUN_6		31
#define MZ2_INFANTRY_MACHINEGUN_7		32
#define MZ2_INFANTRY_MACHINEGUN_8		33
#define MZ2_INFANTRY_MACHINEGUN_9		34
#define MZ2_INFANTRY_MACHINEGUN_10		35
#define MZ2_INFANTRY_MACHINEGUN_11		36
#define MZ2_INFANTRY_MACHINEGUN_12		37
#define MZ2_INFANTRY_MACHINEGUN_13		38

#define MZ2_SOLDIER_BLASTER_1			39
#define MZ2_SOLDIER_BLASTER_2			40
#define MZ2_SOLDIER_SHOTGUN_1			41
#define MZ2_SOLDIER_SHOTGUN_2			42
#define MZ2_SOLDIER_MACHINEGUN_1		43
#define MZ2_SOLDIER_MACHINEGUN_2		44

#define MZ2_GUNNER_MACHINEGUN_1			45
#define MZ2_GUNNER_MACHINEGUN_2			46
#define MZ2_GUNNER_MACHINEGUN_3			47
#define MZ2_GUNNER_MACHINEGUN_4			48
#define MZ2_GUNNER_MACHINEGUN_5			49
#define MZ2_GUNNER_MACHINEGUN_6			50
#define MZ2_GUNNER_MACHINEGUN_7			51
#define MZ2_GUNNER_MACHINEGUN_8			52
#define MZ2_GUNNER_GRENADE_1			53
#define MZ2_GUNNER_GRENADE_2			54
#define MZ2_GUNNER_GRENADE_3			55
#define MZ2_GUNNER_GRENADE_4			56

#define MZ2_CHICK_ROCKET_1				57

#define MZ2_FLYER_BLASTER_1				58
#define MZ2_FLYER_BLASTER_2				59

#define MZ2_MEDIC_BLASTER_1				60

#define MZ2_GLADIATOR_RAILGUN_1			61

#define MZ2_HOVER_BLASTER_1				62

#define MZ2_ACTOR_MACHINEGUN_1			63

#define MZ2_SUPERTANK_MACHINEGUN_1		64
#define MZ2_SUPERTANK_MACHINEGUN_2		65
#define MZ2_SUPERTANK_MACHINEGUN_3		66
#define MZ2_SUPERTANK_MACHINEGUN_4		67
#define MZ2_SUPERTANK_MACHINEGUN_5		68
#define MZ2_SUPERTANK_MACHINEGUN_6		69
#define MZ2_SUPERTANK_ROCKET_1			70
#define MZ2_SUPERTANK_ROCKET_2			71
#define MZ2_SUPERTANK_ROCKET_3			72

#define MZ2_BOSS2_MACHINEGUN_L1			73
#define MZ2_BOSS2_MACHINEGUN_L2			74
#define MZ2_BOSS2_MACHINEGUN_L3			75
#define MZ2_BOSS2_MACHINEGUN_L4			76
#define MZ2_BOSS2_MACHINEGUN_L5			77
#define MZ2_BOSS2_ROCKET_1				78
#define MZ2_BOSS2_ROCKET_2				79
#define MZ2_BOSS2_ROCKET_3				80
#define MZ2_BOSS2_ROCKET_4				81

#define MZ2_FLOAT_BLASTER_1				82

#define MZ2_SOLDIER_BLASTER_3			83
#define MZ2_SOLDIER_SHOTGUN_3			84
#define MZ2_SOLDIER_MACHINEGUN_3		85
#define MZ2_SOLDIER_BLASTER_4			86
#define MZ2_SOLDIER_SHOTGUN_4			87
#define MZ2_SOLDIER_MACHINEGUN_4		88
#define MZ2_SOLDIER_BLASTER_5			89
#define MZ2_SOLDIER_SHOTGUN_5			90
#define MZ2_SOLDIER_MACHINEGUN_5		91
#define MZ2_SOLDIER_BLASTER_6			92
#define MZ2_SOLDIER_SHOTGUN_6			93
#define MZ2_SOLDIER_MACHINEGUN_6		94
#define MZ2_SOLDIER_BLASTER_7			95
#define MZ2_SOLDIER_SHOTGUN_7			96
#define MZ2_SOLDIER_MACHINEGUN_7		97
#define MZ2_SOLDIER_BLASTER_8			98
#define MZ2_SOLDIER_SHOTGUN_8			99
#define MZ2_SOLDIER_MACHINEGUN_8		100


#define	MZ2_MAKRON_BFG					101
#define MZ2_MAKRON_BLASTER_1			102
#define MZ2_MAKRON_BLASTER_2			103
#define MZ2_MAKRON_BLASTER_3			104
#define MZ2_MAKRON_BLASTER_4			105
#define MZ2_MAKRON_BLASTER_5			106
#define MZ2_MAKRON_BLASTER_6			107
#define MZ2_MAKRON_BLASTER_7			108
#define MZ2_MAKRON_BLASTER_8			109
#define MZ2_MAKRON_BLASTER_9			110
#define MZ2_MAKRON_BLASTER_10			111
#define MZ2_MAKRON_BLASTER_11			112
#define MZ2_MAKRON_BLASTER_12			113
#define MZ2_MAKRON_BLASTER_13			114
#define MZ2_MAKRON_BLASTER_14			115
#define MZ2_MAKRON_BLASTER_15			116
#define MZ2_MAKRON_BLASTER_16			117
#define MZ2_MAKRON_BLASTER_17			118
#define MZ2_MAKRON_RAILGUN_1			119
#define	MZ2_JORG_MACHINEGUN_L1			120
#define	MZ2_JORG_MACHINEGUN_L2			121
#define	MZ2_JORG_MACHINEGUN_L3			122
#define	MZ2_JORG_MACHINEGUN_L4			123
#define	MZ2_JORG_MACHINEGUN_L5			124
#define	MZ2_JORG_MACHINEGUN_L6			125
#define	MZ2_JORG_MACHINEGUN_R1			126
#define	MZ2_JORG_MACHINEGUN_R2			127
#define	MZ2_JORG_MACHINEGUN_R3			128
#define	MZ2_JORG_MACHINEGUN_R4			129
#define MZ2_JORG_MACHINEGUN_R5			130
#define	MZ2_JORG_MACHINEGUN_R6			131
#define MZ2_JORG_BFG_1					132
#define MZ2_BOSS2_MACHINEGUN_R1			133
#define MZ2_BOSS2_MACHINEGUN_R2			134
#define MZ2_BOSS2_MACHINEGUN_R3			135
#define MZ2_BOSS2_MACHINEGUN_R4			136
#define MZ2_BOSS2_MACHINEGUN_R5			137


#define	MZ2_CARRIER_MACHINEGUN_L1		138
#define	MZ2_CARRIER_MACHINEGUN_R1		139
#define	MZ2_CARRIER_GRENADE				140
#define MZ2_TURRET_MACHINEGUN			141
#define MZ2_TURRET_ROCKET				142
#define MZ2_TURRET_BLASTER				143
#define MZ2_STALKER_BLASTER				144
#define MZ2_DAEDALUS_BLASTER			145
#define MZ2_MEDIC_BLASTER_2				146
#define	MZ2_CARRIER_RAILGUN				147
#define	MZ2_WIDOW_DISRUPTOR				148
#define	MZ2_WIDOW_BLASTER				149
#define	MZ2_WIDOW_RAIL					150
#define	MZ2_WIDOW_PLASMABEAM			151		
#define	MZ2_CARRIER_MACHINEGUN_L2		152
#define	MZ2_CARRIER_MACHINEGUN_R2		153
#define	MZ2_WIDOW_RAIL_LEFT				154
#define	MZ2_WIDOW_RAIL_RIGHT			155
#define	MZ2_WIDOW_BLASTER_SWEEP1		156
#define	MZ2_WIDOW_BLASTER_SWEEP2		157
#define	MZ2_WIDOW_BLASTER_SWEEP3		158
#define	MZ2_WIDOW_BLASTER_SWEEP4		159
#define	MZ2_WIDOW_BLASTER_SWEEP5		160
#define	MZ2_WIDOW_BLASTER_SWEEP6		161
#define	MZ2_WIDOW_BLASTER_SWEEP7		162
#define	MZ2_WIDOW_BLASTER_SWEEP8		163
#define	MZ2_WIDOW_BLASTER_SWEEP9		164
#define	MZ2_WIDOW_BLASTER_100			165
#define	MZ2_WIDOW_BLASTER_90			166
#define	MZ2_WIDOW_BLASTER_80			167
#define	MZ2_WIDOW_BLASTER_70			168
#define	MZ2_WIDOW_BLASTER_60			169
#define	MZ2_WIDOW_BLASTER_50			170
#define	MZ2_WIDOW_BLASTER_40			171
#define	MZ2_WIDOW_BLASTER_30			172
#define	MZ2_WIDOW_BLASTER_20			173
#define	MZ2_WIDOW_BLASTER_10			174
#define	MZ2_WIDOW_BLASTER_0				175
#define	MZ2_WIDOW_BLASTER_10L			176
#define	MZ2_WIDOW_BLASTER_20L			177
#define	MZ2_WIDOW_BLASTER_30L			178
#define	MZ2_WIDOW_BLASTER_40L			179
#define	MZ2_WIDOW_BLASTER_50L			180
#define	MZ2_WIDOW_BLASTER_60L			181
#define	MZ2_WIDOW_BLASTER_70L			182
#define	MZ2_WIDOW_RUN_1					183
#define	MZ2_WIDOW_RUN_2					184
#define	MZ2_WIDOW_RUN_3					185
#define	MZ2_WIDOW_RUN_4					186
#define	MZ2_WIDOW_RUN_5					187
#define	MZ2_WIDOW_RUN_6					188
#define	MZ2_WIDOW_RUN_7					189
#define	MZ2_WIDOW_RUN_8					190
#define	MZ2_CARRIER_ROCKET_1			191
#define	MZ2_CARRIER_ROCKET_2			192
#define	MZ2_CARRIER_ROCKET_3			193
#define	MZ2_CARRIER_ROCKET_4			194
#define	MZ2_WIDOW2_BEAMER_1				195
#define	MZ2_WIDOW2_BEAMER_2				196
#define	MZ2_WIDOW2_BEAMER_3				197
#define	MZ2_WIDOW2_BEAMER_4				198
#define	MZ2_WIDOW2_BEAMER_5				199
#define	MZ2_WIDOW2_BEAM_SWEEP_1			200
#define	MZ2_WIDOW2_BEAM_SWEEP_2			201
#define	MZ2_WIDOW2_BEAM_SWEEP_3			202
#define	MZ2_WIDOW2_BEAM_SWEEP_4			203
#define	MZ2_WIDOW2_BEAM_SWEEP_5			204
#define	MZ2_WIDOW2_BEAM_SWEEP_6			205
#define	MZ2_WIDOW2_BEAM_SWEEP_7			206
#define	MZ2_WIDOW2_BEAM_SWEEP_8			207
#define	MZ2_WIDOW2_BEAM_SWEEP_9			208
#define	MZ2_WIDOW2_BEAM_SWEEP_10		209
#define	MZ2_WIDOW2_BEAM_SWEEP_11		210
 
 

extern monster_flash_offset() as vec3_t 



enum temp_event_t 

	TE_GUNSHOT,
	TE_BLOOD,
	TE_BLASTER,
	TE_RAILTRAIL,
	TE_SHOTGUN,
	TE_EXPLOSION1,
	TE_EXPLOSION2,
	TE_ROCKET_EXPLOSION,
	TE_GRENADE_EXPLOSION,
	TE_SPARKS,
	TE_SPLASH,
	TE_BUBBLETRAIL,
	TE_SCREEN_SPARKS,
	TE_SHIELD_SPARKS,
	TE_BULLET_SPARKS,
	TE_LASER_SPARKS,
	TE_PARASITE_ATTACK,
	TE_ROCKET_EXPLOSION_WATER,
	TE_GRENADE_EXPLOSION_WATER,
	TE_MEDIC_CABLE_ATTACK,
	TE_BFG_EXPLOSION,
	TE_BFG_BIGEXPLOSION,
	TE_BOSSTPORT,			
	TE_BFG_LASER,
	TE_GRAPPLE_CABLE,
	TE_WELDING_SPARKS,
	TE_GREENBLOOD,
	TE_BLUEHYPERBLASTER,
	TE_PLASMA_EXPLOSION,
	TE_TUNNEL_SPARKS,
	TE_BLASTER2,
	TE_RAILTRAIL2,
	TE_FLAME,
	TE_LIGHTNING,
	TE_DEBUGTRAIL,
	TE_PLAIN_EXPLOSION,
	TE_FLASHLIGHT,
	TE_FORCEWALL,
	TE_HEATBEAM,
	TE_MONSTER_HEATBEAM,
	TE_STEAM,
	TE_BUBBLETRAIL2,
	TE_MOREBLOOD,
	TE_HEATBEAM_SPARKS,
	TE_HEATBEAM_STEAM,
	TE_CHAINFIST_SMOKE,
	TE_ELECTRIC_SPARKS,
	TE_TRACKER_EXPLOSION,
	TE_TELEPORT_EFFECT,
	TE_DBALL_GOAL,
	TE_WIDOWBEAMOUT,
	TE_NUKEBLAST,
	TE_WIDOWSPLASH,
	TE_EXPLOSION1_BIG,
	TE_EXPLOSION1_NP,
	TE_FLECHETTE
end enum


#define SPLASH_UNKNOWN		0
#define SPLASH_SPARKS		1
#define SPLASH_BLUE_WATER	2
#define SPLASH_BROWN_WATER	3
#define SPLASH_SLIME		4
#define	SPLASH_LAVA			5
#define SPLASH_BLOOD		6
 


#define	CHAN_AUTO               0
#define	CHAN_WEAPON             1
#define	CHAN_VOICE              2
#define	CHAN_ITEM               3
#define	CHAN_BODY               4

#define	CHAN_NO_PHS_ADD			8	
#define	CHAN_RELIABLE			16	

#define	ATTN_NONE               0	
#define	ATTN_NORM               1
#define	ATTN_IDLE               2
#define	ATTN_STATIC             3	

#define STAT_HEALTH_ICON		0
#define	STAT_HEALTH				1
#define	STAT_AMMO_ICON			2
#define	STAT_AMMO				3
#define	STAT_ARMOR_ICON			4
#define	STAT_ARMOR				5
#define	STAT_SELECTED_ICON		6
#define	STAT_PICKUP_ICON		7
#define	STAT_PICKUP_STRING		8
#define	STAT_TIMER_ICON			9
#define	STAT_TIMER				10
#define	STAT_HELPICON			11
#define	STAT_SELECTED_ITEM		12
#define	STAT_LAYOUTS			13
#define	STAT_FRAGS				14
#define	STAT_FLASHES			15		
#define STAT_CHASE				16
#define STAT_SPECTATOR			17


#define	MAX_STATS				32

#define	DF_NO_HEALTH		&H00000001	
#define	DF_NO_ITEMS			&H00000002	
#define	DF_WEAPONS_STAY		&H00000004	
#define	DF_NO_FALLING		&H00000008	
#define	DF_INSTANT_ITEMS	&H00000010	
#define	DF_SAME_LEVEL		&H00000020	
#define DF_SKINTEAMS		&H00000040	
#define DF_MODELTEAMS		&H00000080	
#define DF_NO_FRIENDLY_FIRE	&H00000100	
#define	DF_SPAWN_FARTHEST	&H00000200	
#define DF_FORCE_RESPAWN	&H00000400	
#define DF_NO_ARMOR			&H00000800	
#define DF_ALLOW_EXIT		&H00001000	
#define DF_INFINITE_AMMO	&H00002000	
#define DF_QUAD_DROP		&H00004000	
#define DF_FIXED_FOV		&H00008000	

#define	DF_QUADFIRE_DROP	&H00010000	

 
#define DF_NO_MINES			&H00020000
#define DF_NO_STACK_DOUBLE	&H00040000
#define DF_NO_NUKES			&H00080000
#define DF_NO_SPHERES		&H00100000
 
#define ROGUE_VERSION_ID		1278

#define ROGUE_VERSION_STRING	"08/21/1998 Beta 2 for Ensemble"


'LOOKS GOOD make sure its fine'''''''''''''''''''''''''''''''''
#define	ANGLE2SHORT(x)	(cast(integer,((x)*65536/360)) and 65535)
#define	SHORT2ANGLE(x)	((x)*(360.0/65536))
'''''''''''''''''''''''''''''''''''''''''''''

 #define	CS_NAME				0
#define	CS_CDTRACK			1
#define	CS_SKY				2
#define	CS_SKYAXIS			3		 
#define	CS_SKYROTATE		4
#define	CS_STATUSBAR		5		 

#define  CS_AIRACCEL			29		 
#define	CS_MAXCLIENTS		30
#define	CS_MAPCHECKSUM		31		 

#define	CS_MODELS			32
#define	CS_SOUNDS			(CS_MODELS+MAX_MODELS)
#define	CS_IMAGES			(CS_SOUNDS+MAX_SOUNDS)
#define	CS_LIGHTS			(CS_IMAGES+MAX_IMAGES)
#define	CS_ITEMS			   (CS_LIGHTS+MAX_LIGHTSTYLES)
#define	CS_PLAYERSKINS		(CS_ITEMS+MAX_ITEMS)
#define  CS_GENERAL			(CS_PLAYERSKINS+MAX_CLIENTS)
#define	MAX_CONFIGSTRINGS	(CS_GENERAL+MAX_GENERAL)
 
 
 
 
 
 
enum entity_event_t 
	EV_NONE,
	EV_ITEM_RESPAWN,
	EV_FOOTSTEP,
	EV_FALLSHORT,
	EV_FALL,
	EV_FALLFAR,
	EV_PLAYER_TELEPORT,
	EV_OTHER_TELEPORT
 
 

End Enum
 

type entity_state_s

 
	number as integer		

	origin as vec3_t	
	angles as vec3_t	
	old_origin as vec3_t	
	modelindex as integer	
	as integer		modelindex2, modelindex3, modelindex4 
	frame as integer		
	skinnum as integer		
	effects as uinteger		
	renderfx as integer		
	solid  as Integer
						 
							 
	_sound as integer				 
	event as integer					 
						 
						 
end type: type entity_state_t as entity_state_s
 
 
 type player_state_t
 	
 	pmove as pmove_state_t 

 
   viewangles as vec3_t	
	viewoffset as	vec3_t	 
   kick_angles as vec3_t
	 

	gunangles as vec3_t	
	gunoffset as vec3_t		
	gunindex  as integer			
	gunframe  as  integer			

	blend(4) as float	 
	
	fov as float	 

	rdflags as	integer	 

	stats(MAX_STATS)	as short 
 	
 	
 End Type



#define VIDREF_GL		1
#define VIDREF_SOFT	2
#define VIDREF_OTHER	3

extern vidref_val as integer 
 
