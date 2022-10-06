

#Include "win32\conproc.bi"
#include "crt\process.bi"




 sub DeinitConProc () 
 	
 	
 End Sub
 
 
 
sub InitConProc(argc as integer,argv as zstring ptr ptr)
	
'		unsigned	threadAddr;
'	HANDLE		hFile;
'	HANDLE		heventParent;
'	HANDLE		heventChild;
'	int			t;
'
'	ccom_argc = argc;
'	ccom_argv = argv;
'
'// give QHOST a chance to hook into the console
'	if ((t = CCheckParm ("-HFILE")) > 0)
'	{
'		if (t < argc)
'			hFile = (HANDLE)atoi (ccom_argv[t+1]);
'	}
'		
'	if ((t = CCheckParm ("-HPARENT")) > 0)
'	{
'		if (t < argc)
'			heventParent = (HANDLE)atoi (ccom_argv[t+1]);
'	}
'		
'	if ((t = CCheckParm ("-HCHILD")) > 0)
'	{
'		if (t < argc)
'			heventChild = (HANDLE)atoi (ccom_argv[t+1]);
'	}
'
'
'// ignore if we don't have all the events.
'	if (!hFile || !heventParent || !heventChild)
'	{
'		printf ("Qhost not present.\n");
'		return;
'	}
'
'	printf ("Initializing for qhost.\n");
'
'	hfileBuffer = hFile;
'	heventParentSend = heventParent;
'	heventChildSend = heventChild;
'
'// so we'll know when to go away.
'	heventDone = CreateEvent (NULL, _false, _false, NULL);
'
'	if (!heventDone)
'	{
'		printf ("Couldn't create heventDone\n");
'		return;
'	}
'
'	if (!_beginthreadex (NULL, 0, RequestProc, NULL, 0, &threadAddr))
'	{
'		CloseHandle (heventDone);
'		printf ("Couldn't create QHOST thread\n");
'		return;
'	}
'
'// save off the input/output handles.
'	hStdout = GetStdHandle (STD_OUTPUT_HANDLE);
'	hStdin = GetStdHandle (STD_INPUT_HANDLE);
'
'// force 80 character width, at least 25 character height
'	SetConsoleCXCY (hStdout, 80, 25);
'	
	'_beginthreadex (NULL, 0, RequestProc, NULL, 0, @threadAddr)
End Sub
