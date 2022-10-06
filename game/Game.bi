

type  as edict_s edict_t 
type as  gclient_s gclient_t 

type edict_s
 
	'entity_state_t	s;
	'struct gclient_s	*client;
	as qboolean	inuse 
	'int			linkcount;

	'// FIXME: move these fields to a server private sv_entity_t
	'link_t		area;				// linked to a division node or leaf
	'
	'int			num_clusters;		// if -1, use headnode instead
	'int			clusternums[MAX_ENT_CLUSTERS];
	'int			headnode;			// unused if num_clusters != -1
	'int			areanum, areanum2;

	'//================================

	'int			svflags;			// SVF_NOCLIENT, SVF_DEADMONSTER, SVF_MONSTER, etc
	'vec3_t		mins, maxs;
	'vec3_t		absmin, absmax, size;
	'solid_t		solid;
	'int			clipmask;
	'edict_t		*owner;

	'// the game dll can add anything it wants after
	'// this point in the structure
end type