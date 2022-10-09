#include "crt.bi"

#Include "client\ref.bi"

#Include "client\vid.bi"
#Include "client\input.bi"
#Include "client\keys.bi"
#Include "client\console.bi"
#Include "client\screen.bi"
#Include "client\cdaudio.bi"
#Include "client\sound.bi"

declare sub CL_InitInput ()

extern as cvar_t	ptr cl_stereo_separation
extern as cvar_t	ptr cl_stereo

extern as cvar_t	ptr cl_gun
extern as cvar_t	ptr cl_add_blend
extern as cvar_t	ptr cl_add_lights
extern as cvar_t	ptr cl_add_particles
extern as cvar_t	ptr cl_add_entities
extern as cvar_t	ptr cl_predict
extern as cvar_t	ptr cl_footsteps
extern as cvar_t	ptr cl_noskins
extern as cvar_t	ptr cl_autoskins

extern as cvar_t	ptr cl_upspeed
extern as cvar_t	ptr cl_forwardspeed
extern as cvar_t	ptr cl_sidespeed

extern as cvar_t	ptr cl_yawspeed
extern as cvar_t	ptr cl_pitchspeed

extern as cvar_t	ptr cl_run

extern as cvar_t	ptr cl_anglespeedkey

extern as cvar_t	ptr cl_shownet
extern as cvar_t	ptr cl_showmiss
extern as cvar_t	ptr cl_showclamp

extern as cvar_t	ptr lookspring
extern as cvar_t	ptr lookstrafe
extern as cvar_t	ptr sensitivity

extern as cvar_t	ptr m_pitch
extern as cvar_t	ptr m_yaw
extern as cvar_t	ptr m_forward
extern as cvar_t	ptr m_side

extern as cvar_t	ptr freelook

extern as cvar_t	ptr cl_lightlevel	'// FIXME HACK

extern as cvar_t	ptr cl_paused
extern as cvar_t	ptr cl_timedemo

extern as cvar_t	ptr cl_vwep

extern as refexport_t	re 		'// interface to refresh .dll

 enum  connstate_t
 
   ca_uninitialized,
	ca_disconnected, 	'// not talking to a server
	ca_connecting,		'// sending request packets to the server
	ca_connected,		'// netchan_t established, waiting for svc_serverdata
	ca_active			'// game v
 
 End Enum
 




type client_static_t
	
	
	as connstate_t	state 
	as float 	disable_screen 	
	
	
End Type

extern as	client_static_t	_cls





declare sub V_Init ()


declare sub M_Init ()