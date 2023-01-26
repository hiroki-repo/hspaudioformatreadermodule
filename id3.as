#ifndef _GOCAINE_ID3MOD_
#module _GOCAINE_ID3MOD_
#define BE2LE32(%1) ((((%1>>(8*0))&0xFF)<<(8*3))|(((%1>>(8*1))&0xFF)<<(8*2))|(((%1>>(8*2))&0xFF)<<(8*1))|(((%1>>(8*3))&0xFF)<<(8*0)))
#define BE2LE24(%1) ((((%1>>(8*0))&0xFF)<<(8*2))|(((%1>>(8*1))&0xFF)<<(8*1))|(((%1>>(8*2))&0xFF)<<(8*0)))
#deffunc GetID3Data str prm_0,str prm_1,var prm_2
exist prm_0:if strsize=-1{return -1}
sdim magic,64:bload prm_0,magic,3,0:if magic!="ID3"{return -1}
id3size=0:bload prm_0,id3size,4,6
sdim id3tag,id3size:bload prm_0,id3tag,id3size,0
sdim id3fid,4
repeat id3size-10
wpoke id3fid,3,0
if (wpeek(id3tag,3)=2){
memcpy id3fid,id3tag,3,0,10+cnt
artmp=(lpeek(id3tag,10+cnt+3)&0xFFFFFF)
artmp=BE2LE24(artmp)
if (id3fid=prm_1){memcpy prm_2,id3tag,artmp,0,10+cnt+6:break}
continue cnt+artmp+6
}else{
memcpy id3fid,id3tag,4,0,10+cnt
artmp=lpeek(id3tag,10+cnt+4)
artmp=BE2LE32(artmp)
if (id3fid=prm_1){memcpy prm_2,id3tag,artmp,0,10+cnt+10:break}
continue cnt+artmp+10
}
loop
return 0
#deffunc GetID3Array str prm_0,array prm_1
exist prm_0:if strsize=-1{return -1}
sdim magic,64:bload prm_0,magic,3,0:if magic!="ID3"{return -1}
cntx=0
id3size=0:bload prm_0,id3size,4,6:id3size=BE2LE32(id3size)
sdim id3tag,id3size:bload prm_0,id3tag,id3size,0
sdim id3fid,4
repeat id3size-10
wpoke id3fid,3,0
if ((cnt&0x7FFFFFFF)>(id3size-10)) | (cnt&0x80000000){break}
if (wpeek(id3tag,3)=2){
memcpy id3fid,id3tag,3,0,10+cnt
if id3fid=""{break}
artmp=(lpeek(id3tag,10+cnt+3)&0xFFFFFF)
artmp=BE2LE24(artmp)
prm_1(cntx,0)=id3fid
prm_1(cntx,1)=""
if artmp>=varsize(prm_1(cntx,1)){
if (varsize(id3tag)-(10+cnt+6))<=varsize(prm_1(cntx,1)){
memcpy prm_1(cntx,1),id3tag,(varsize(id3tag)-(10+cnt+6)),0,10+cnt+6
}else{
memcpy prm_1(cntx,1),id3tag,varsize(prm_1(cntx,1)),0,10+cnt+6
}
}else{
if (varsize(id3tag)-(10+cnt+6))<=artmp{
memcpy prm_1(cntx,1),id3tag,(varsize(id3tag)-(10+cnt+6)),0,10+cnt+6
}else{
memcpy prm_1(cntx,1),id3tag,artmp,0,10+cnt+6
}
}
cntx++
if length(prm_1)<=cntx{break}
continue cnt+artmp+6
}else{
if (varsize(id3tag)-(10+cnt))<4{break}
memcpy id3fid,id3tag,4,0,10+cnt
if id3fid=""{break}
if (varsize(id3tag)-(10+cnt+4))<4{break}
artmp=lpeek(id3tag,10+cnt+4)
artmp=BE2LE32(artmp)
prm_1(cntx,0)=id3fid
prm_1(cntx,1)=""
if artmp>=varsize(prm_1(cntx,1)){
if (varsize(id3tag)-(10+cnt+10))<=varsize(prm_1(cntx,1)){
memcpy prm_1(cntx,1),id3tag,(varsize(id3tag)-(10+cnt+10)),0,10+cnt+10
}else{
memcpy prm_1(cntx,1),id3tag,varsize(prm_1(cntx,1)),0,10+cnt+10
}
}else{
if (varsize(id3tag)-(10+cnt+10))<=artmp{
memcpy prm_1(cntx,1),id3tag,(varsize(id3tag)-(10+cnt+10)),0,10+cnt+10
}else{
memcpy prm_1(cntx,1),id3tag,artmp,0,10+cnt+10
}
}
cntx++
if length(prm_1)<=cntx{break}
continue cnt+artmp+10
}
loop
sdim id3tag,64
return 0
#global
#endif
