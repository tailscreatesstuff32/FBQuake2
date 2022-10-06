'#include "crt.bi"
'#include "file.bi"
'
'dim filename as string = "colormap.pcx"
'
'dim pcx_  as ubyte ptr 
'dim pcx_2  as ubyte ptr 
'dim buff as any ptr ptr
'dim buff2 as  any ptr 
'dim buff3 as  ubyte ptr 
'dim fp as FILE ptr
'
'dim fp2 as file ptr ptr
'
'
'fp2 = @fp
'
'*fp2 = fopen(filename,"rb")
'
'
'
'buff = cast(any ptr ptr, @pcx_)
'
'
'
'pcx_2 =  new ubyte(20)
'*buff = pcx_2 
'
'
'
'
'
'buff2 = pcx_2 
'
'
'
'buff3 = cast(UByte ptr,buff2)
'
'
'fread  buff3  ,1,5,fp
'
'print buff3[0]
'
'
'
'
'free pcx_
'
'
'fclose(fp)
'fp = NULL
'sleep
'





dim arr1(48) as  integer

print ubound(arr1)

sleep







