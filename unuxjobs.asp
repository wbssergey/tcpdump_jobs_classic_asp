<%pgTitle="Unix Job Monitor": sAllowed="1,2": sUPCpntAllowed="ujm"%>
<!--#include file=../include/Header.asp-->
<!--#include file="../include/voipCustomer.asp"-->
<!--#include file=mvtsheader.asp-->

<style type="text/css">
<!--
.wiztelFields {
	width: 160px;
}
.wiztelInputFields {
	font-size:10px;font-weight:normal;font-family:tahoma,sans-serif;width=100;
}
-->
</style>

<%

Dim pid, file, ip
Dim voipCust 
Dim fso
Dim oldlinuxlist, oldlinuxtimelist, oldlinuxsizelist

Set voipCust= New voipCustomer

set fso=createobject("scripting.filesystemobject")

Server.ScriptTimeout = 4000
oConn.CommandTimeout = 4000

MeraUN = MeraUser1  '  "mvts"
MeraPW = " -pw " & MeraPwd1 ' "Gyr)*Rat3" '"defaultMVTS"


intention = Trim(rqF("sIntention"))

proclist=rqf("proclist")
filelist=rqf("filelist")
iplist=rqf("iplist")
readylist=rqf("readylist")
readyiplist=rqf("readyiplist")
oldlist=rqf("oldlist")
oldtimelist=rqf("oldtimelist")
oldlinuxlist=rqf("oldlinuxlist")
oldlinuxtimelist=rqf("oldlinuxtimelist")
oldlinuxsizelist=rqf("oldlinuxsizelist")
stoppidlist=""
stopfilelist=""
stopiplist=""
caddress=rqf("caddress")
vaddress=rqf("vaddress")
ipselected=rqf("ipselected")
fileselected=rqf("fileselected")
gwselected=rqf("gwselected")
CustomerName=rqf("CustomerName")
VendorName=rqF("VendorName")

x1CustId = rqF("sX1CustId")

If x1CustId = "" Then x1CustId="-1" End If

x1VendId = rqF("sX1VendId")

If x1VendId = "" Then x1VendId="-1" End If

MDestination = rqF("sDestination")
MDestinationType = rqF("sDestinationType")
MDestinationMobileCarrier = rqF("sDestinationMobileCarrier")
MDescription = rqF("sDescription")

showoldfiles=rqf("showoldfiles")

set Executor = Server.CreateObject("ASPExec.Execute") 

If intention = "" then

readylist=""
readyiplist=""
oldlist=""
oldtimelist=""
oldlinuxlist=""
oldlinuxtimelist=""
oldlinuxsizelist=""


s1=session("ujreadylist")
s2=session("ujreadyiplist")

s3=session("ujproclist")
s4=session("ujfilelist")
s5=session("ujiplist")

s6=session("ujoldlist")
s7=session("ujoldtimelist")
s8=session("ujoldlinuxlist")
s9=session("ujoldlinuxtimelist")
s10=session("ujoldlinuxsizelist")

If s1 <> "" Then readylist=s1 End If
If s2 <> "" Then readyiplist=s2 End If
If s3 <> "" Then proclist=s3 End If
If s4 <> "" Then filelist=s4 End If
If s5 <> "" Then iplist=s5 End If

If s6 <> "" Then oldlist=s6 End If
If s7 <> "" Then oldtimelist=s7 End If
If s8 <> "" Then oldlinuxlist=s8 End If
If s9 <> "" Then oldlinuxtimelist=s9 End If
If s10 <> "" Then oldlinuxsizelist=s10 End If

UNIXremoteApp = ExePath & "plink.exe -1 "

 s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

 s= s & " -v ./ut1list.pl " 
 
 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
   
ret1 = Executor.ExecuteDosApp 

ScanPS(ret1)

proclist= pid & stoppidlist
filelist= file & stopfilelist
iplist= ip & stopiplist

If oldlist="" then

'set fso=createobject("scripting.filesystemobject")

if not fso.folderexists(TextPath) then 
redirErr("folder does not exists") 
End if


set fld=fso.getfolder(TextPath)

for each fle in fld.files

s=fle.name
p=InStr(s,".cap")
l=Len(s)
If p > 0 And (l=(p+3))Then 

if InStr(filelist,Replace(s,".cap","_cap")) = 0 And InStr(readylist,s) = 0 Then

set mfile= fso.GetFile(TextPath &s)
				
				fsize=mfile.size
                
				fsize=CDbl(fsize)

				fsize= FormatNumber((fsize / 1024.0),2) & " KB "
                fsize=Replace(fsize,",","")

                fdt=mfile.DateLastModified

oldlist=oldlist &"," &s & " (" &fsize & ")" 

oldtimelist=oldtimelist & "," & fdt

End if
End if
Next

End If ' If oldlist="" then

If oldlinuxlist="" then

 s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

 s= s & " -v ./ut2dir.pl '*.cap'" 
 
 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
   
ret1 = Executor.ExecuteDosApp 

ScanDir(ret1)

End If ' If oldlinuxlist="" then

End If ' intention = ""

If intention = "select1x" Then

s=rqf("Parameter")

If s <> "" Then ipselected = s End If

fileselected=CustomerName & ".cap"

intention="refresh"

End If

If intention = "select2x" Then

s=rqf("Parameter")

If s <> "" Then ipselected = s End if

fileselected=VendorName & ".cap"

intention="refresh"

End If

'If instr(intention,"mselect") > 0 Then

'intention="refresh"

'End If


If intention = "refresh" Then


UNIXremoteApp = ExePath & "plink.exe -1 "

 s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

 s= s & " -v ./ut1list.pl " 
 
 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
   
ret1 = Executor.ExecuteDosApp 


ScanPS(ret1)


If  proclist = "" Then
 
 proclist = pid
 filelist=file
 iplist=ip

 Else
 
 
s=Replace(proclist,",","",1,1)

aproclist=Split(s,",")

s=Replace(filelist,",","",1,1)

afilelist=Split(s,",")

s=Replace(iplist,",","",1,1)

aiplist=Split(s,",")

l=UBound(aproclist)

pid=pid & ",,"

For i=0 To l

s1=aproclist(i)

If InStr(pid,","&s1&",") = 0  Then

s2=afilelist(i)
s3=aiplist(i)

stoppidlist=stoppidlist & "," & s1
stopfilelist=stopfilelist & "," & s2
stopiplist=stopiplist & "," & s3

End If

Next

pid=Replace(pid,",,","")

proclist= pid & stoppidlist
filelist= file & stopfilelist
iplist= ip & stopiplist

End If
 

End If 'refresh



If intention = "getfile" Then

s=rqf("Parameter")

ast=Split(s,":")

spid=ast(0)
sfile=ast(1)
sip=ast(2)

spid=Trim(spid)
sfile=Trim(sfile)

sindex = ""

If InStr(sip,".")=0 Then

sindex=sip

sip="?"

End if


UNIXremoteApp = ExePath & "pscp.exe -1 " 

 s="-l " & MeraUN & MeraPW 
 s=s & " " & MeraUN & "@" & MeraHost & ":/home/mvts/"&sfile
 s=s & " " & TextPath 


 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
   
ret1 = Executor.ExecuteDosApp 


UNIXremoteApp = ExePath & "plink.exe -1 "

Executor.Application = UNIXremoteApp

s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

fsize="?"

'set fso = server.CreateObject("Scripting.FileSystemObject")

filePathName = TextPath & sfile

if  not fso.FileExists(filePathName) then 

Response.Write "<script>alert('Result file was not copied from Linux to Windows!\nPlease alert the system Administrator!');</script>"

					
Else
              
				set mfile= fso.GetFile(filePathName)
				
				fsize=mfile.size
                
				fsize=CDbl(fsize)

				fsize= FormatNumber((fsize / 1024.0),2) & " KB "
                fsize=Replace(fsize,",","")

			    Executor.Parameters = s & " -v rm -f /home/mvts/"&sfile


                Executor.ShowWindow = false 
   
                ret1 = Executor.ExecuteDosApp 
          
End If
                
 
 Executor.Application = UNIXremoteApp
 
 Executor.Parameters =  s & " -v ./ut1list.pl " 
  
 Executor.ShowWindow = false 
   
ret1 = Executor.ExecuteDosApp 

ScanPS(ret1)

pid=pid & ",,"

proclist=proclist & ",,"

proclist=Replace(proclist,"," & spid & ",",",0," )

proclist=Replace(proclist,",,","")

s=Replace(proclist,",","",1,1)

aproclist=Split(s,",")

s=Replace(filelist,",","",1,1)

afilelist=Split(s,",")

s=Replace(iplist,",","",1,1)

aiplist=Split(s,",")

l=UBound(aproclist)

'redirerr proclist & " <br> " & filelist & " <br> " & iplist & " <br> " & pid

For i=0 To l

s1=aproclist(i)

If (InStr(pid,","&s1&",") = 0) And (s1 <> "0")  Then


s2=afilelist(i)
s3=aiplist(i)

stoppidlist=stoppidlist & "," & s1
stopfilelist=stopfilelist & "," & s2
stopiplist=stopiplist & "," & s3

End If

Next

pid=Replace(pid,",,","")

proclist= pid & stoppidlist
filelist= file & stopfilelist
iplist= ip & stopiplist

readylist=readylist & "," & sfile & " ("&fsize&")"
readyiplist=readyiplist & "," & sip

If sindex <> "" Then

If oldlinuxlist <> "" Then

s=Replace(oldlinuxlist,",","",1,1)
alinready=Split(s,",")
s=Replace(oldlinuxtimelist,",","",1,1)
alintmready=Split(s,",")
s=Replace(oldlinuxsizelist,",","",1,1)
alinsizezready=Split(s,",")

sindex=CInt(sindex)

u=""
v=""
w=""

For i=0 To l

If i <> sindex Then

u= u & "," &alinready(i)
v= v & "," & alintmready(i)
w= w & "," & alinsizezready(i)
End If

Next

oldlinuxlist=u
oldlinuxtimelist=v
oldlinuxsizelist=w

End If ' If oldlinuxlist <> "" Then

End If ' sindex <> ""

End If 'getfile

If intention = "deletelinuxoldfile" Then

s=rqf("Parameter")
ast=Split(s,":")
sfile=ast(0)
sindex=ast(1)


UNIXremoteApp = ExePath & "plink.exe -1 "

Executor.Application = UNIXremoteApp

s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

 Executor.Parameters = s & " -v rm -f /home/mvts/"&sfile
  
 Executor.ShowWindow = false 
   
 ret2 = Executor.ExecuteDosApp 

u=""
v=""
w=""

If oldlinuxlist <> "" Then

s=Replace(oldlinuxlist,",","",1,1)
alinready=Split(s,",")
s=Replace(oldlinuxtimelist,",","",1,1)
alintmready=Split(s,",")
s=Replace(oldlinuxsizelist,",","",1,1)
alinsizezready=Split(s,",")

l=UBound(alinready)

sindex=CInt(sindex)

For i=0 To l

If i <> sindex Then

u= u & "," &alinready(i)
v= v & "," & alintmready(i)
w= w & "," & alinsizezready(i)
End If

Next

oldlinuxlist=u
oldlinuxtimelist=v
oldlinuxsizelist=w

End If ' oldlinuxlist <> ""

End If 'deletelinuxoldfile

If intention = "delete" Or intention = "deleteold" Then

s=rqf("Parameter")
ast=Split(s,":")
sfile=ast(0)
sindex=ast(1)

p=InStr(sfile,".cap")
if p > 0 then
sfile=Mid(sfile,1,p+3)
End if

sfile=TextPath & sfile


switchUser 1

'set fso=createobject("scripting.filesystemobject")
If fso.FileExists(sfile) Then
   fso.DeleteFile sfile 
Else
Response.Write "<script>alert('File does not exist!\nPlease alert the system Administrator!');</script>"
End If 

switchUser 0

'Set fso = Nothing

u=""

v=""

If intention = "delete" then

If readylist <> "" Then

s=Replace(readylist,",","",1,1)
aready=Split(s,",")
s=Replace(readyiplist,",","",1,1)
areadyip=Split(s,",")
l=UBound(aready)

sindex=CInt(sindex)

For i=0 To l

If i <> sindex Then
u= u & "," &aready(i)
v= v & "," &areadyip(i)
End if
Next

readylist=u
readyiplist=v

End If 'readylist <> ""

End If

If intention = "deleteold" Then

If oldlist <> "" Then

s=Replace(oldlist,",","",1,1)
aready=Split(s,",")
s=Replace(oldtimelist,",","",1,1)
atmready=Split(s,",")

l=UBound(aready)

sindex=CInt(sindex)

For i=0 To l

If i <> sindex Then

u= u & "," &aready(i)
v= v & "," & atmready(i)

End if
Next

oldlist=u
oldtimelist=v

End If 'oldlist <> ""

End If

End If 'delete or deleteold

If intention = "stop" Then

s=rqf("Parameter")
'redirerr s
ast=Split(s,":")
spid=ast(0)
sfile=ast(1)
sip=ast(2)

spid=Trim(spid)
sfile=Trim(sfile)

' -- stop linux process

UNIXremoteApp = ExePath & "plink.exe -1 "

Executor.Application = UNIXremoteApp

s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

Executor.Parameters = s & " -v ./ut1stop.pl " & spid
  
Executor.ShowWindow = false 
   
ret1 = Executor.ExecuteDosApp 

' -- getfile

UNIXremoteApp = ExePath & "pscp.exe -1 " 

 
 s="-l " & MeraUN & MeraPW 
 s=s & " " & MeraUN & "@" & MeraHost & ":/home/mvts/"&sfile
 s=s & " " & TextPath 


 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
   
ret2 = Executor.ExecuteDosApp 

UNIXremoteApp = ExePath & "plink.exe -1 "

Executor.Application = UNIXremoteApp

s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

fsize="?"

'set fso = server.CreateObject("Scripting.FileSystemObject")

filePathName = TextPath & sfile

if  not fso.FileExists(filePathName) then 

Response.Write "<script>alert('Result file was not copied from Linux to Windows!\nPlease alert the system Administrator!');</script>"

					
Else
              
				set mfile= fso.GetFile(filePathName)
				
				fsize=mfile.size
 
                fsize=CDbl(fsize)

				fsize= FormatNumber((fsize / 1024.0),2) & " KB "
                fsize=Replace(fsize,",","")

 Executor.Parameters = s & " -v rm -f /home/mvts/"&sfile
  
 Executor.ShowWindow = false 
   
 ret2 = Executor.ExecuteDosApp 
				 
End If
  

ScanPS(ret1)

pid=pid & ",,"

proclist=proclist & ",,"

proclist=Replace(proclist,"," & spid & ",",",0," )

proclist=Replace(proclist,",,","")


s=Replace(proclist,",","",1,1)

aproclist=Split(s,",")

s=Replace(filelist,",","",1,1)

afilelist=Split(s,",")

s=Replace(iplist,",","",1,1)

aiplist=Split(s,",")

l=UBound(aproclist)

'redirerr proclist & " <br> " & filelist & " <br> " & iplist & " <br> " & pid

For i=0 To l

s1=aproclist(i)

If (InStr(pid,","&s1&",") = 0) And (s1 <> "0")  Then


s2=afilelist(i)
s3=aiplist(i)

stoppidlist=stoppidlist & "," & s1
stopfilelist=stopfilelist & "," & s2
stopiplist=stopiplist & "," & s3

End If

Next

pid=Replace(pid,",,","")

proclist= pid & stoppidlist
filelist= file & stopfilelist
iplist= ip & stopiplist

readylist=readylist & "," & sfile & " ("&fsize&")"
readyiplist=readyiplist & "," & sip

End If 'stop


If intention = "run" Then

ip=rqf("IP")
fname=rqf("Name")
tm=rqf("TimeOut")
desc=rqf("Desc")

if desc <> "" Then
desc=Trim(desc)
End if

If fname <> "" Then 

fname=Trim(fname)

p=InStr(fname,".cap")

If p > 0 Then

s=""

If desc <> "" Then s="_" & desc End if

fname=Mid(fname,1,p-1) & s & ".cap"

End If

End If


If ip <> "" Then ip=Trim(ip) End If

If tm <> "" Then tm=Trim(tm) End If

If ip = "" Then
redirerr ("IP Address must be not empty")
End If

If Not IsValidIp(ip) Then
redirerr ("Please use valid IP Address")
End If

If fname = "" Then
redirerr ("Filename must be not empty")
End If


If InStr(fname,".cap") = 0 Then
redirerr ("Please use extension .cap in filename")
End If

If desc <> "" then
If InStr(desc,"_") > 0 Then
redirerr ("Sorry, Underscore Character '_' is not allowed in the description field : <b> - " & desc & " </b> " )
End If
End If

s=Replace(fname,".cap","_cap")

s1=filelist & ","
s2=readylist & ","

'redirerr fname & " : " & filelist & " : " & readylist

If InStr(s1,","&s&",") > 0 Or InStr(s2,","&fname&" (") > 0 Or InStr(s2,","&fname&",") > 0 Then

redirerr ("Duplicate FileName, please use other description field -<b>" & desc & "</b> -  for this name : <b>" & fname &"</b>")

End If

If tm = "" Then
redirerr ("TimeOut must be not empty")
End If

If Not isnumberm(tm) Then
redirerr ("TimeOut must be integer >= 0 ")
End If


MeraUN = MeraUser2  
MeraPW = " -pw " & MeraPwd2 

UNIXremoteApp = ExePath & "plink.exe -1 "

 s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 

 s= s & " -v ./ut1.pl " & ip & " " & fname & " " & tm
 
 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
  
 
ret1 = Executor.ExecuteDosApp 


ScanPS(ret1)

 
 If  proclist = "" Then
 
 proclist = pid
 filelist=file
 iplist=ip

 Else
 
 
s=Replace(proclist,",","",1,1)

aproclist=Split(s,",")

s=Replace(filelist,",","",1,1)

afilelist=Split(s,",")

s=Replace(iplist,",","",1,1)

aiplist=Split(s,",")

l=UBound(aproclist)

pid=pid & ",,"

For i=0 To l

s1=aproclist(i)

If InStr(pid,","&s1&",") = 0  Then

s2=afilelist(i)
s3=aiplist(i)

stoppidlist=stoppidlist & "," & s1
stopfilelist=stopfilelist & "," & s2
stopiplist=stopiplist & "," & s3

End If

Next

pid=Replace(pid,",,","")

proclist= pid & stoppidlist
filelist= file & stopfilelist
iplist= ip & stopiplist

End If
 

End If ' run

If intention = "select1" Then

caddress=""

s=rqf("Parameter")

If s <> "" then

sql="select Address from tblVoIPGatewayConfigs where id="&s

Set rs=oconn.execute(sql)
If not rs.eof then
caddress=rs("address")
End if
rs.close

End If

End If ' select1

If intention = "select2" Then

vaddress = ""

s=rqf("Parameter")

If s <> "" then
sql="select Address from tblVoIPGatewayConfigs where id="&s
Set rs=oconn.execute(sql)
If not rs.eof then
vaddress=rs("address")
End if

rs.close

End If

End If ' select2


%>
<table width=680><tr><td style=letter-spacing:1;font-size:10pt;font-weight:bold;color:#646496> &nbsp;<%=PgTitle%></td></tr>
</table>

<form name="fSubmit" method="post" action="">

  <table  width="800" border="0" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" class="datatable">
    <tr class="datacol1"> 
      <td width="85">&nbsp;Customer: </td>
      <td width="168"><select name="fX1CustId" id="fX1CustId" class="wiztelFields" onchange="return doSubmit('mselectc','')">
          <option value="-1" >---- All ---- </option>
		  <%=voipCust.WriteCustomerList(X1CustId)%>
        </select></td>
		</tr>
<tr><td colspan=2>&nbsp;</td> </tr>
    
<tr class="datacol0"> 
    
		 <td width="85">&nbsp;Vendor: </td>
      <td width="168"><select name="fX1VendId" id="fX1VendId" class="wiztelFields" onchange="return doSubmit('mselectv','')">
          <option value="-1" >---- All ---- </option>
	  	  <%=voipCust.WriteRouteActiveVendorList(X1VendId)%>
        </select></td>
	
	      </tr>
			<tr class="datacol0"> 
			<td>&nbsp;Destination: </td>
      <td><select name="mDestination" id="mselect2" class="wiztelFields" onchange="return doSubmit('mselect','')">
          <option value="" selected>----All ----</option>
		   <option value="A-Z" <%If MDestination="A-Z" then%>selected<%End if%>>A-Z</option>
			<%=voipCust.WriteDestinationList(MDestination)%>
        </select></td>
      
      <td>Destination Type:</td>
      <td><select name="mDestinationType" id="mselect3" class="wiztelFields" onchange="return doSubmit('mselectx','')">
          <option value="" selected>&nbsp;&nbsp;&nbsp;&nbsp;---- All ---- &nbsp;&nbsp;&nbsp;&nbsp;</option>
		  <%=voipCust.WriteDestinationTypeList(MDestination, MDestinationType)%>
        </select></td>
      <td>Mobile Carrier:</td>
      <td><select name="mDestinationMobileCarrier" id="mselect4" class="wiztelFields" onchange="return doSubmit('mselecty','')">
          <option value="" selected>&nbsp;&nbsp;&nbsp;&nbsp;---- All ---- &nbsp;&nbsp;&nbsp;&nbsp;</option>
		  <%=voipCust.WriteMobileCarrierList(MDestination, MDestinationType, MDestinationMobileCarrier)%>
        </select></td>
      <td>&nbsp;Description:</td>
      <td><select name="mDescription" id="mselect1" class="wiztelFields" onchange="return doSubmit('mselectz','')">
          <option value="" selected>&nbsp;&nbsp;&nbsp;&nbsp;---- All ---- &nbsp;&nbsp;&nbsp;&nbsp;</option>
		  <%=voipCust.WriteDescriptionList(MDestination, MDestinationType, MDescription)%>
        </select></td>

      </tr>
    
   </table>
<br><br>
<table width="100%">
<tr class=datacol1><td width=130>Customer Gateway:</td>
<td>
<%

sql="select id, name from tblVoIPGatewayConfigs where  gwmode = 1 " 

If x1custid <> "-1" Then
sql=sql & " and custid="&x1custid
End if

If Mdestination <> "" then
'sql=sql & " and vdsname='"&Mdestination&"'"
End If

If MDestinationType <> "" then
'sql=sql & " and vdsType='"&MDestinationType &"'"
End If

If MDestinationMobileCarrier <> "" then
'sql=sql & " and vdsMobileCarrier='"&MDestinationMobileCarrier &"'"
End If

If MDescription <> "" then
'sql=sql & " and vdsDescription='"&MDescription &"'"
End If

sql=sql & " order by Name"

Set rs=oconn.execute(sql)

%>
<select name="CustomerGW"  onchange="return doSubmit('select1','')">
<option value="">--Select--</option>
<%
While Not rs.eof
id=rs("id")
name=rs("name")
%>
<option value="<%=id%>" <%If name=CustomerName then%>selected<%End if%>><%=name%></option>
<%
rs.movenext
Wend
rs.close
%>
</select>
</td>
<%
If caddress <> "" Then
arip=Split(caddress,";")
l=UBound(arip)
v=rqf("CustomerIP")
%>
<td>&nbsp;&nbsp;&nbsp;&nbsp;IP Address:</td>
<td> 
<select name="CustomerIP" >
<option value="">--Select--</option>
<%
For i=0 To l
s=arip(i)
%>
<option value="<%=s%>" <%If s=v then%> selected <%End if%>><%=s%></option>
<%
Next
%>
</select>
<td align=center><input class=databutton type=button name=Copy value="Add New Job (Customer Gateway)" 
onclick="return doSubmit('select1x','')">
</td>
<%
End If 'caddress <> ""
%>
</tr>
<tr class=datacol0><td width=130>Vendor Gateway:</td>
<td>
<%

sql="select * from tblVoIPGatewayConfigs where  gwmode = 2"

If x1vendid <> "-1" Then
sql=sql & " and custid="&x1vendid
End if

If Mdestination <> "" then
sql=sql & " and vdsname='"&Mdestination&"'"
End If

If MDestinationType <> "" then
sql=sql & " and vdsType='"&MDestinationType &"'"
End If

If MDestinationMobileCarrier <> "" then
sql=sql & " and vdsMobileCarrier='"&MDestinationMobileCarrier &"'"
End If

If MDescription <> "" then
sql=sql & " and vdsDescription='"&MDescription &"'"
End If

sql=sql & " order by Name"

Set rs=oconn.execute(sql)

%>
<select name="VendorGW"  onchange="return doSubmit('select2','')">
<option value="">--Select--</option>
<%
While Not rs.eof
id=rs("id")
name=rs("name")
%>
<option value="<%=id%>" <%If name=VendorName then%>selected<%End if%>><%=name%></option>
<%
rs.movenext
Wend
rs.close
%>
</select>
</td>
<%
If vaddress <> "" Then
arip=Split(vaddress,";")
l=UBound(arip)
v=rqf("VendorIP")
%>
<td>&nbsp;&nbsp;&nbsp;&nbsp;IP Address:</td><td> 
<select name="VendorIP" >
<option value="">--Select--</option>
<%
For i=0 To l
s=arip(i)
%>
<option value="<%=s%>" <%If s=v then%> selected <%End if%>><%=s%></option>
<%
Next
%>
</select>
</td>

<td align=center><input class=databutton type=button name=Copy value="Add New Job (Vendor Gateway)" 
onclick="return doSubmit('select2x','')">
</td>

<%
End If 'address <> ""
%>

</td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td  nowrap>&nbsp;&nbsp;Show Old Files&nbsp;&nbsp;
        <input type=checkbox class=datacheckboxn  
        name="showoldfiles" value="y" <%If showoldfiles = "y" then%> checked <%End if%> 
		onclick="return doSubmit('mselectshow','')" >
        </td>

</tr>
</table>
<br><br>
<table>
<tr class=datarow1><td colspan=2 align=center><b>New Job</b></td>
</tr>
<tr class=datarow0>
<th style=text-align:right width=200>IP Address:</th>
<%
a=ipselected

b=fileselected

v=rqf("IP")

u=rqf("Name")

w=rqF("TimeOut")

If v <> a Then v = a end If
If u <> b Then u = b end If
If w = "" Then w = "120" end If

%>
<td><input class=datatext type=text  name="IP"  readonly size=60 value="<%=v%>"></td>
</tr>
<tr class=datarow0>
<th style=text-align:right width=200>FileName:</th>
<td><input class=datatext type=text  name="Name"  readonly size=60 value="<%=u%>"></td>
</tr>
<tr class=datarow0>
<th style=text-align:right width=200>Description:</th>
<td><input class=datatext type=text  name="Desc" size=60 value=""></td>
</tr>
<tr class=datarow0>
<th style=text-align:right width=200>TimeOut (sec):</th>
<td><input class=datatext type=text  name="TimeOut"  size=60 value="<%=w%>"></td>
</tr>

<tr class=datarow1>
<td></td>
<td align=center>
<input class=databutton type=button value="Run"  
			onclick="return doSubmit('run','');">	
			<%=spacesHtml(40)%>
<input class=databutton type=button value="Refresh"  
			onclick="return doSubmit('refresh','');">		

</tr>


</table>

<br>

<%
If (pid <> "") Or (stoppidlist <> "") Or (readylist <> "" ) then
%>


<table  width="100%"  >
<%
If True Then ' oldlist <> "" And showoldfiles <> "" Then
%>
<tr class=datarow1>
<td colspan=4 align=center><b>This Session Files</b></td>
</tr>
<%
End if
%>
<th style=text-align:center>Process</th>
<th style=text-align:center>IP</th>
<th style=text-align:center>FileName</th>
<th style=text-align:center>Action</th>

<%

If pid <> "" then

pid=Replace(pid,",","",1,1)
file=Replace(file,",","",1,1)
apid=Split(pid,",")
afile=Split(file,",")
ip=replace(ip,",","",1,1)
aip=Split(ip,",")
l=UBound(apid)
%>

<% For i=0 To l
p=Trim(apid(i))
f=Trim(afile(i))
f=Replace(f,"_cap",".cap")
ip=aip(i)
%>
<tr class=datarow0>
<td style=text-align:center valign=top><%=p%></td>
<td style=text-align:center valign=top><%=ip%></td>
<td style=text-align:center valign=top><%=f%></td><td align=center>
<a href="/z.asp" onclick="return doSubmit('stop','<%=p%>:<%=f%>:<%=ip%>');">Stop Process</a>
<!--
<input class=databutton type=button value="Stop" onclick="return doSubmit('stop','<%=p%>:<%=f%>:<%=ip%>');">		
-->
</td>
</tr>
<%
Next
End If ' pid = ""

If stoppidlist <> "" then

stoppidlist=Replace(stoppidlist,",","",1,1)
stopfilelist=Replace(stopfilelist,",","",1,1)
stopiplist=Replace(stopiplist,",","",1,1)


apid1=Split(stoppidlist,",")
afile1=Split(stopfilelist,",")
aip1=Split(stopiplist,",")
l=UBound(apid1)


For i=0 To l
p=Trim(apid1(i))
f=Trim(afile1(i))
f=Replace(f,"_cap",".cap")
ip=aip1(i)
%>
<tr class=datarow0>
<td style=text-align:center valign=top>&nbsp;</td>
<td style=text-align:center valign=top><%=ip%></td>
<td style=text-align:center valign=top><%=f%></td>
<td align=center>
<a href="/z.asp" onclick="return doSubmit('getfile','<%=p%>:<%=f%>:<%=ip%>');">Get File</a>
<!--
<input class=databutton type=button value="Get File" onclick="return doSubmit('getfile','<%=p%>:<%=f%>:<%=ip%>');">		
-->
</td>
</tr>
<%
Next
End If ' stoplist = ""

If readylist <> "" Then
s=Replace(readylist,",","",1,1)

aready=Split(s,",")
s=Replace(readyiplist,",","",1,1)
areadyip=Split(s,",")

l=UBound(aready)

For i=0 To l
f=Trim(aready(i))
f=Replace(f,"_cap",".cap")

ip=areadyip(i)
%>
<tr class=datarow0>
<td style=text-align:center valign=top>&nbsp;</td>
<td style=text-align:center valign=top><%=ip%></td>
<td style=text-align:center valign=top><%=f%></td>
<%
s=""
p=InStr(f,".cap")
if p > 0 then
s=Mid(f,1,p+3)
End if

WebLink=application("weblink")    

iWebFileName = WebLink & "/invoiceHTMLs/" & s
	
%>
<td align=center>
<a href="<%=iWebFileName%>" target="_blank">View File</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="/z.asp" onclick="return doSubmit('delete','<%=f%>:<%=i%>');">Delete File</a>

</td>
</tr>
<%
Next

End If ' readylist

%>

</table>

<%
End If ' If (pid <> "") Or (stoppidlist <> "") Or (readylist <> "" )  then

If oldlist <> "" And showoldfiles <> "" Then

%>
<table width="100%">
<tr class=datarow1>
<td colspan=3 align=center><b>Old Windows Files</b></td>
</tr>

<th style=text-align:center>FileName</th>
<th style=text-align:center>TimeCreated</th>
<th style=text-align:center>Action</th>

<%

s=Replace(oldlist,",","",1,1)

aready=Split(s,",")

s=Replace(oldtimelist,",","",1,1)

atmready=Split(s,",")

l=UBound(aready)

For i=0 To l
f=Trim(aready(i))
f=Replace(f,"_cap",".cap")

s=""
p=InStr(f,".cap")
if p > 0 then
s=Mid(f,1,p+3)
End if

tm=atmready(i)

tm1=GetDtModified(s)

tm=cstr(tm)

tm1=CStr(tm1)

tm2=tm

If tm <> tm1 Then tm2 = tm1 End If

%>
<tr class=datarow0>
<td style=text-align:left valign=top nowrap><%=f%></td>
<td style=text-align:center valign=top nowrap><%=tm2%></td>

<%
s=""
p=InStr(f,".cap")
if p > 0 then
s=Mid(f,1,p+3)
End if

WebLink=application("weblink")    

iWebFileName = WebLink & "/invoiceHTMLs/" & s
	
%>
<td align=center>
<%If tm = tm1 then%>
<a href="<%=iWebFileName%>" target="_blank">View File</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="/z.asp" onclick="return doSubmit('deleteold','<%=f%>:<%=i%>');">Delete File</a>
<%Else
If tm2 <> "" then%>
File Was Overwritten
<%else%>
File Was Deleted
<%
End if
End if%>
</td>
</tr>
<%
Next

End If ' oldlist

If oldlinuxlist <> "" And showoldfiles <> "" Then
%>

<tr class=datarow1>
<td colspan=3 align=center><b>Old Linux Files</b></td>
</tr>

<th style=text-align:center>FileName</th>
<th style=text-align:center>TimeCreated</th>
<th style=text-align:center>Action</th>

<%

s=Replace(oldlinuxlist,",","",1,1)

alinready=Split(s,",")

s=Replace(oldlinuxtimelist,",","",1,1)

alintmready=Split(s,",")

s=Replace(oldlinuxsizelist,",","",1,1)

alinsizeready=Split(s,",")

l=UBound(alinready)

For i=0 To l
f=Trim(alinready(i))
f=Replace(f,"_cap",".cap")

's=""
'p=InStr(f,".cap")
'if p > 0 then
's=Mid(f,1,p+3)
'End if
tm=alintmready(i)

tm1=GetLinuxDtModified(f)

tm2=tm

If tm <> tm1 Then tm2=tm1 End If

sz=alinsizeready(i)

sz=CDbl(sz) /1024.

sz=FormatNumber(sz,2)
sz=Replace(sz,",","")

s=f & " ("&sz& "KB )"

%>
<tr class=datarow0>
<td style=text-align:left valign=top nowrap><%=s%></td>
<td style=text-align:center valign=top nowrap><%=tm2%></td>

<td align=center>
<%If tm = tm1 then%>
<a href="/z.asp" onclick="return doSubmit('getfile','0:<%=f%>:<%=i%>');">Get File</a>
<!--
<a href="/z.asp" onclick="return doSubmit('getlinuxoldfile','<%=f%>');">Get File</a>
-->
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="/z.asp" onclick="return doSubmit('deletelinuxoldfile','<%=f%>:<%=i%>');">Delete File</a>
<%else
If tm2 <> "" then%>
File Was Overwritten
<%else%>
File Was Deleted
<%
End if
End if%>
</td>
</tr>
<%

Next


End If ' If oldlinuxlist <> "" And showoldfiles <> "" Then

%>
</table>

<input type=hidden name="sIntention" value="">
<input type=hidden name="Parameter" value="">
<input type=hidden name="proclist" value="<%=proclist%>">
<input type=hidden name="filelist" value="<%=filelist%>">
<input type=hidden name="iplist" value="<%=iplist%>">
<input type=hidden name="readylist" value="<%=readylist%>">
<input type=hidden name="readyiplist" value="<%=readyiplist%>">
<input type=hidden name="caddress" value="<%=caddress%>">
<input type=hidden name="vaddress" value="<%=vaddress%>">
<input type=hidden name="ipselected" value="<%=ipselected%>">
<input type=hidden name="fileselected" value="<%=fileselected%>">
<input type=hidden name="gwselected" value="<%=gwselected%>">
<input type=hidden name="CustomerName" value="<%=CustomerName%>">
<input type=hidden name="VendorName" value="<%=VendorName%>">
<input type=hidden name="oldlist" value="<%=oldlist%>">
<input type=hidden name="oldtimelist" value="<%=oldtimelist%>">
<input type=hidden name="oldlinuxlist" value="<%=oldlinuxlist%>">
<input type=hidden name="oldlinuxtimelist" value="<%=oldlinuxtimelist%>">
<input type=hidden name="oldlinuxsizelist" value="<%=oldlinuxsizelist%>">

<input type=hidden name="sDestination" id="sDestination" value="">
<input type=hidden name="sDestinationType" id="sDestinationType" value="">
<input type=hidden name="sDestinationMobileCarrier" id="sDestinationMobileCarrier" value="">
<input type=hidden name="sDescription" id="sDescription" value="">
<input type=hidden name="sX1CustId" id="sX1CustId" >
<input type=hidden name="sX1VendId" id="sX1VendId" >

</form>

<%

Function ScanFile(uret)
Dim ret1
Dim list,timelist,sizelist

ret1=ClearAlphaN(uret)

u="_"

u2=u & u

do until instr(ret1,u2)=0

ret1=Replace(ret1,u2,u)

loop


 p1=InStr(ret1,"lsbegin")
 p2=InStr(ret1,"lsend")
  

 If (p1 > 0) And (p2 > 0) Then
 
 r=Mid(ret1, p1, p2-p1)

 q=1
 
 list=""
 timelist=""
 sizelist=""

  While Not (q = 0)
  s=""
  s1=""
  s2=""

  p1=InStr(q,r,"root_root_")
  
  
  If p1 > 0 Then
  
  p2=InStr(p1+10,r,"size")
  p3=InStr(p1+10,r,"time")
    
  If (p2 > 0) And (p3 > 0) then
  s=Mid(r,p2+4,p3-p2-4)
  End if
  
  sizelist=sizelist & "," & s & ":"

 
  p4=InStr(p3,r,"file")
   
 
  If (p4 > 0) Then

  s1=Mid(r,p3+4,p4-p3-4)
  
  End If
  
  If s1 <> "" Then 
  s1=Replace(s1,"_"," ",1,2)
  s1=Replace(s1,"_",":",1,1)
  End if


  timelist=timelist & "," & s1

 
  p5=InStr(p4,r,"endzfile")
 
  If p5 > 0 Then
  
  s2=Mid(r,p4+4,p5-p4-4)

  End If
  
  
  list=list & "," & s2
   
  q=p2

  Else
  
  q=0

  End If
  

  Wend
  
  
 Else

 redirerr ("cannot scan: <br> " & uret)
 
 End if 
 
 If timelist <> "" Then 
 timelist=Replace(timelist,",","",1,1) 
 End if
 
 ScanFile=timelist


End Function

Function ScanFileZ(uret)
Dim ret1
Dim list,timelist,sizelist

ret1=ClearAlphaN(uret)

u="_"

u2=u & u

do until instr(ret1,u2)=0

ret1=Replace(ret1,u2,u)

loop


 p1=InStr(ret1,"psbegin")
 p2=InStr(ret1,"psend")
  

 If (p1 > 0) And (p2 > 0) Then
 
 r=Mid(ret1, p1, p2-p1)


 q=1
 
 list=""
 timelist=""
 sizelist=""

  While Not (q = 0)
  s=""
  s1=""
  s2=""

  p1=InStr(q,r,"root_root_")
  
  
  If p1 > 0 Then
  
  p2=InStr(p1+10,r,"_")
  
  s=Mid(r,p1+10,p2-p1-10)

  
  sizelist=sizelist & "," & s

  p11next=InStr(p1+10,r,"root_root")
  p12next=InStr(p1+10,r,"mvts_mvts")
  p1next=0
 
  If (p11next = 0) And (p12next = 0) Then 
  p1next = Len(r) 
  Else

  If p11next = 0 Then p1next=p12next End If
  If p12next = 0 Then p1next=p11next End If

  If p1next = 0 Then
  
  If p11next < p12next Then
  p1next=p11next
  Else
  p1next=p12next
  End if
  
  End If
  
  End If

 'endpage p11next & " " & p12next & " " & p1next

  p3=InstrRev(r,"_cap_",p1next)
  
  p4=0
  p41=InstrRev(r,"C_",p3)
  p42=InstrRev(r,"V_",p3)
  
  If (p41 > 0) And (p42 > 0) Then
  
  If p41 < p42 Then
  p4=p42
  Else
  p4=p41
  End if
  
  Else
  
  If p41 > 0 Then p4=p41 End If
  If p42 > 0 Then p4=p42 End if
  
  End If
  

  
 
  If p4 > 0 Then


  s1=Mid(r,p4,p3-p4+4)
  
  'If s1 <> "" Then s1=Replace(s1,"_cap",".cap")  End if

  End if

  list=list & "," & s1

  p5=InStr(p2,r,s1)
  
  'endpage p2x & " " & p5 & " " & s1

  If p5 > 0 Then
  
  s2=Mid(r,p2+1,p5-p2-2)

  End If
  
  If s2 <> "" Then
  
  s2=Replace(s2,"_"," ",1,2)
  s2=Replace(s2,"_",":",1,1)

  End If
  

  timelist=timelist & "," & s2

  q=p2

  Else
  
  q=0

  End If
  

  Wend
  
  'redirerr oldlinuxlist & ", <br> " & oldlinuxsizelist & ", <br> " & oldlinuxtimelist &":"

 Else

 redirerr ("cannot scan: <br> " & uret)
 
 End if 
 
 If timelist <> "" Then 
 timelist=Replace(timelist,",","",1,1) 
 End if
 
 ScanFileZ=timelist


End Function

Function ScanDir(uret)
Dim ret1

ret1=ClearAlphaN(uret)

u="_"

u2=u & u

do until instr(ret1,u2)=0

ret1=Replace(ret1,u2,u)

loop


 p1=InStr(ret1,"lsbegin")
 p2=InStr(ret1,"lsend")
  

 If (p1 > 0) And (p2 > 0) Then
 
 r=Mid(ret1, p1, p2-p1)

 q=1
 
 oldlinuxlist=""
 oldlinuxtimelist=""
 oldlinuxsizelist=""

  While Not (q = 0)
  s=""
  s1=""
  s2=""

  p1=InStr(q,r,"root_root_")
  
  
  If p1 > 0 Then
  
    
  p2=InStr(p1+10,r,"size")
  p3=InStr(p1+10,r,"time")
    
  If (p2 > 0) And (p3 > 0) then
  s=Mid(r,p2+4,p3-p2-4)
  End if
  
  oldlinuxsizelist=oldlinuxsizelist & "," & s

 
  p4=InStr(p3,r,"file")
   
 
  If (p4 > 0) Then

  s1=Mid(r,p3+4,p4-p3-4)
  
  End If
  
  If s1 <> "" Then 
  s1=Replace(s1,"_"," ",1,2)
  s1=Replace(s1,"_",":",1,1)
  End if

  oldlinuxtimelist=oldlinuxtimelist & "," & s1

   
  p5=InStr(p4,r,"endzfile")
 
  If p5 > 0 Then
  
  s2=Mid(r,p4+4,p5-p4-4)

  End If
  

  oldlinuxlist=oldlinuxlist & "," & s2
  
  q=p2

  Else
  
  q=0

  End If
  

  Wend
  
'  redirerr oldlinuxlist & ", <br> " & oldlinuxsizelist & ", <br> " & oldlinuxtimelist &":"

 Else

 redirerr ("cannot scan: <br> " & uret)
 
 End if 
 
End Function

function ScanPS(uret)
Dim ret1

ret1=ClearAlphaN(uret)

u="_"

u2=u & u

do until instr(ret1,u2)=0

ret1=Replace(ret1,u2,u)

loop


 p1=InStr(ret1,"psbegin")
 p2=InStr(ret1,"psend")
  

 If (p1 > 0) And (p2 > 0) Then
 
 r=Mid(ret1, p1, p2-p1)

 q=1
 pid=""
 file=""
 ip=""
 
 
 While Not (q = 0)
 
 p3=InStr(q,r,"pcap_")
 If p3 = 0 then
 p3=InStr(q,r,"root_")
 End If

 If p3 > 0 then

 p4=InStr(p3+5,r,"_")

 p41=InStr(p4,r,"_host")

 p5=InStr(p4,r,"_w")

 s=Mid(r,p41+6,p5-2-p41-4)

 s=Replace(s,"_",".")
  
 ip=ip & "," & s

 'p5=InStr(p4,r,"_w")

 p6=InStr(p5+3,r,"_cap")
 p7=InStr(p6+1,r,"_")
 
 pid=pid & "," & Mid(r,p3+5,p4-p3-5)

 file=file & "," & Mid(r,p5+3,p7-p5-3)

 q=p7+1

 Else
 
 q=0

 End If
 
 Wend


 Else

 redirerr ("cannot scan: <br> " & uret)
 
 End if 

end function

Function ScanDirz(uret)
Dim ret1

ret1=ClearAlphaN(uret)

u="_"

u2=u & u

do until instr(ret1,u2)=0

ret1=Replace(ret1,u2,u)

loop


 p1=InStr(ret1,"psbegin")
 p2=InStr(ret1,"psend")
  

 If (p1 > 0) And (p2 > 0) Then
 
 r=Mid(ret1, p1, p2-p1)


 q=1
 
 oldlinuxlist=""
 oldlinuxtimelist=""
 oldlinuxsizelist=""

  While Not (q = 0)
  s=""
  s1=""
  s2=""

  p1=InStr(q,r,"root_root_")
  
  
  If p1 > 0 Then
  
  p2=InStr(p1+10,r,"_")
  
  s=Mid(r,p1+10,p2-p1-10)

  
  oldlinuxsizelist=oldlinuxsizelist & "," & s

  p11next=InStr(p1+10,r,"root_root")
  p12next=InStr(p1+10,r,"mvts_mvts")
  p1next=0
 
  If (p11next = 0) And (p12next = 0) Then 
  p1next = Len(r) 
  Else

  If p11next = 0 Then p1next=p12next End If
  If p12next = 0 Then p1next=p11next End If

  If p1next = 0 Then
  
  If p11next < p12next Then
  p1next=p11next
  Else
  p1next=p12next
  End if
  
  End If
  
  End If

 'endpage p11next & " " & p12next & " " & p1next

  p3=InstrRev(r,"_cap_",p1next)
  
  p4=0
  p41=InstrRev(r,"C_",p3)
  p42=InstrRev(r,"V_",p3)
  
  If (p41 > 0) And (p42 > 0) Then
  
  If p41 < p42 Then
  p4=p42
  Else
  p4=p41
  End if
  
  Else
  
  If p41 > 0 Then p4=p41 End If
  If p42 > 0 Then p4=p42 End if
  
  End If
  

  
 
  If p4 > 0 Then


  s1=Mid(r,p4,p3-p4+4)
  
  'If s1 <> "" Then s1=Replace(s1,"_cap",".cap")  End if

  End if

  oldlinuxlist=oldlinuxlist & "," & s1

  p5=InStr(p2,r,s1)
  
  'endpage p2x & " " & p5 & " " & s1

  If p5 > 0 Then
  
  s2=Mid(r,p2+1,p5-p2-2)

  End If
  
  If s2 <> "" Then
  
  s2=Replace(s2,"_"," ",1,2)
  s2=Replace(s2,"_",":",1,1)

  End If
  

  oldlinuxtimelist=oldlinuxtimelist & "," & s2

  q=p2

  Else
  
  q=0

  End If
  

  Wend
  
  'redirerr oldlinuxlist & ", <br> " & oldlinuxsizelist & ", <br> " & oldlinuxtimelist &":"

 Else

 redirerr ("cannot scan: <br> " & uret)
 
 End if 
 
End Function


Function GetLinuxDtModified(fname)
Dim r,s

UNIXremoteApp = ExePath & "plink.exe -1 "

 s = MeraUN & "@" & MeraHost & " -l " & MeraUN & MeraPW 


 s= s & " -v ./ut2dir.pl " & fname
 
 Executor.Application = UNIXremoteApp
 
 Executor.Parameters = s
  
 Executor.ShowWindow = false 
   
r = Executor.ExecuteDosApp 

s=ScanFile(r)

GetLinuxDtModified=s

End Function


Function GetDtModified(fname)
Dim mfile, fdt, s

s=TextPath & fname

if  not fso.FileExists(s) then 

fdt=""

Else

set mfile= fso.GetFile(s)
				
fdt=mfile.DateLastModified 'DateCreated

End If

GetDtModified=fdt

End Function


session("ujreadylist")=readylist
session("ujreadyiplist")=readyiplist
session("ujproclist")=proclist
session("ujfilelist")=filelist
session("ujiplist")=iplist
session("ujoldlist")=oldlist
session("ujoldtimelist")=oldtimelist
session("ujoldlinuxlist")=oldlinuxlist
session("ujoldlinuxtimelist")=oldlinuxtimelist
session("ujoldlinuxsizelist")=oldlinuxsizelist


set fso=Nothing

%>

<script language=Javascript>

var fs=document.forms.fSubmit; fs.action=''; 

function doSubmit(itn,prm) {
var s;		
		itn = itn.toLowerCase();

		s = fs.fX1CustId.options[fs.fX1CustId.selectedIndex].value;
		
		fs.sX1CustId.value =s;

         s = fs.fX1VendId.options[fs.fX1VendId.selectedIndex].value;
		
		fs.sX1VendId.value =s;

		s1=fs.mDestination.options[fs.mDestination.selectedIndex].value;			

	    fs.sDestination.value = s1;

		fs.sDestinationType.value = fs.mDestinationType.options[fs.mDestinationType.selectedIndex].value;				
		fs.sDestinationMobileCarrier.value = fs.mDestinationMobileCarrier.options[fs.mDestinationMobileCarrier.selectedIndex].value;
		fs.sDescription.value = fs.mDescription.options[fs.mDescription.selectedIndex].value;

        fs.sIntention.value = itn;

	switch (itn) {

	    case 'select1':
		 s=fs.CustomerGW.options[fs.CustomerGW.selectedIndex].value;
		 fs.Parameter.value= s; 
         fs.CustomerName.value=fs.CustomerGW.options[fs.CustomerGW.selectedIndex].text; 

	     fs.submit(); 
			
		break
        
		case 'select2':
		 s=fs.VendorGW.options[fs.VendorGW.selectedIndex].value;
        	 fs.Parameter.value=  s;
             fs.VendorName.value=fs.VendorGW.options[fs.VendorGW.selectedIndex].text; 
	
	          fs.submit(); 
			
		break
       
		case 'select1x':
		 s=fs.CustomerIP.options[fs.CustomerIP.selectedIndex].value;
		 if (s=='')
         {
		 alert('Please select IP address');
		 return false;
         } 	 
		
		 fs.Parameter.value=  s;
	     fs.submit(); 
			
		break
        
		case 'select2x':
		s=fs.VendorIP.options[fs.VendorIP.selectedIndex].value;
        if (s=='')
         {
		 alert('Please select IP address');
		 return false;
         } 	 
	
			 fs.Parameter.value= s;
	
	          fs.submit(); 
			
		break

		case 'run':
		        fs.ipselected.value='';
				fs.fileselected.value='';
				fs.sIntention.value = 'run';
            	fs.submit(); 
				break
	    
		case 'refresh':

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

        case 'stop':
		        fs.Parameter.value= prm;
                fs.sIntention.value = 'stop';
            	fs.submit(); 
				break
       case 'view':
   		        fs.Parameter.value= prm;
                fs.sIntention.value = 'view';
            	fs.submit(); 
				break

	         
       case 'delete':
	         fs.Parameter.value= prm;
             fs.sIntention.value = 'delete';
             fs.submit(); 
			 break
      case 'deleteold':
	         fs.Parameter.value= prm;
             fs.sIntention.value = 'deleteold';
             fs.submit(); 
			 break

      case 'deletelinuxoldfile':

             fs.Parameter.value= prm;
             fs.sIntention.value = 'deletelinuxoldfile';
             fs.submit(); 
			 break
  
       case 'getfile':
		        fs.Parameter.value= prm;
                fs.sIntention.value = 'getfile';
            	fs.submit(); 
				break

case 'mselectshow':

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

case 'mselectc':
                fs.ipselected.value='';
 				fs.fileselected.value='';
		//	fs.VendorName.value='';
            fs.CustomerName.value='';
    fs.caddress.value='';
   // fs.vaddress.value='';

	//	fs.sDestinationType.value = '';
	//	fs.sDestinationMobileCarrier.value = '';
	//	fs.sDescription.value =  '';

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

case 'mselectv':
                fs.ipselected.value='';
 				fs.fileselected.value='';
			fs.VendorName.value='';
        //    fs.CustomerName.value='';
   //  fs.caddress.value='';
    fs.vaddress.value='';

		fs.sDestinationType.value = '';
		fs.sDestinationMobileCarrier.value = '';
		fs.sDescription.value =  '';

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

case 'mselect':
                fs.ipselected.value='';
 				fs.fileselected.value='';
			fs.VendorName.value='';
        //    fs.CustomerName.value='';
   //  fs.caddress.value='';
    fs.vaddress.value='';

		fs.sDestinationType.value = '';
		fs.sDestinationMobileCarrier.value = '';
		fs.sDescription.value =  '';

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break


        case 'mselectx':

 fs.ipselected.value='';
 fs.fileselected.value='';
		fs.VendorName.value='';
      //      fs.CustomerName.value='';
	  //	fs.caddress.value='';
    fs.vaddress.value='';
	
		fs.sDestinationMobileCarrier.value = '';
		fs.sDescription.value =  '';

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

		case 'mselecty':

 fs.ipselected.value='';
 fs.fileselected.value='';
		fs.VendorName.value='';
         //   fs.CustomerName.value='';
		//	fs.caddress.value='';
    fs.vaddress.value='';

		fs.sDescription.value =  '';

		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

		case 'mselectz':

 fs.ipselected.value='';
 fs.fileselected.value='';
		fs.VendorName.value='';
        //    fs.CustomerName.value='';
	// fs.caddress.value='';
    fs.vaddress.value='';


		        fs.sIntention.value = 'refresh';
            	fs.submit(); 
				break

		default:
				fs.submit();
				break	
		}

		return false;
	}

	
	////***********************************************
 

</script>



<!--#include file=../include/footer.asp-->

