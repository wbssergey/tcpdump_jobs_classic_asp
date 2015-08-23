
<%

Dim TextPath, ExePath, DPConfigsOnWin, GWConfigsOnWin

' TextPath = "X:\inetpub\wwwroot\wiztel\pub\invoiceHTMLs\" '@development
' TextPath = "C:\Inetpub\wwwroot\wiztel\invoiceHTMLs\" ' @production
' ExePath = "X:\inetpub\wwwroot\wiztel\pub\manager\schedule\" '@development
' ExePath = "C:\Inetpub\wwwroot\wiztel\manager\schedule\"  '@production

TextPath = application("textpath") ' @virtual from global.asa
ExePath = application("exepath")   ' @virtual from global.asa
MeraHost = application("merahost") ' @virtual from global.asa

MeraUser1= application("merauser1") 
MeraPwd1=  application("merapwd1") 
MeraUser2=application("merauser2")  
MeraPwd2= application("merapwd2")  
'DPConfigsOnWin="DPConfigsOnWin.txt"
'GWConfigsOnWin="GWConfigsOnWin.txt"
'DPConfigsOnWinBak="DPConfigsOnWin.bak"
'GWConfigsOnWinBak="DPConfigsOnWin.bak"

GWConfigsOnWin="gateway.cfg"

DPConfigsOnWin="dialpeer.cfg"

GWConfigsOnWinBak="gateway.bak"

DPConfigsOnWinBak="dialpeer.bak"

%>

