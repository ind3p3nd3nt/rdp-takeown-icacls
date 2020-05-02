#!/bin/bash
# include this boilerplate
# GITHUB REPO: https://github.com/independentcod/rdp-takeown-icacls
# -
# This bash script will configure Windows to allow and deny two different person on the computer from accessing/executing each others data.
# Will also deny any access of denyuser to System32 and SysWOW64 important files.
# I had this idea when people were starting to screw with my remote desktop server.
# INSTALLATION: You will need git-bash to run this script.
#               Then you just configure it the way you want it and execute it.
############
#  CONFIG  #
############
directory="C:\\USERS\\independent\\"
file="list.txt"
denyuser="ADMIN"
grantuser="independent"
quote='"'
rpar=")"
lpar="("
d2=":"
function setstr()
{
# Setting up strings concatenations
tgtobjstr="$quote$1$d2$lpar"
tgtobjstr+="OI"
tgtobjstr+="$rpar"
tgtobjstr+="$lpar"
tgtobjstr+="CI"
tgtobjstr+="$rpar"
tgtobjstr+="F"
tgtobjstr+="$quote"
echo $tgtobjstr;
}
function rdfile()
{
echo Reading File: $file begin.
while IFS= read -r line
do
chk $directory $line
done <"$file"
}
function  lstaccfiles()
{
ls $directory | grep script >>$1;
ls $directory | grep .vbs >>$1;
ls $directory | grep admin >>$1;
ls $directory | grep powershell >>$1;
ls $directory | grep .cmd >>$1;
ls $directory | grep net.exe >>$1;
ls $directory | grep reg. >>$1;
ls $directory | grep del. >>$1;
ls $directory | grep mv. >>$1;
ls $directory | grep run >>$1;
ls $directory | grep ipconfig >>$1;
ls $directory | grep format >>$1;
ls $directory | grep netstat >>$1;
ls $directory | grep .msc >>$1;
ls $directory | grep shutdown >>$1;
ls $directory | grep takeown >>$1;
ls $directory | grep icacls >>$1;
ls $directory | grep task >>$1;
}
function chk()
{
var="$quote"
var+="$1"
var+="$2"
var+="$quote"
echo "Taking owner ship of the file/directory $var";
ps1="start /REALTIME powershell Invoke-Expression \"takeown.exe /D Y /A /R /F' $var\""
eval $ps1;
echo "Setting ownership to $grantuser on $var";
ps2="start /REALTIME powershell Invoke-Expression \"icacls.exe $var /setowner $grantuser /T /Q /C\""
eval $ps2;
echo "Giving Full permission to: $grantuser and denying $denyuser in: $var with container inheritance"
ps3="start /REALTIME powershell Invoke-Expression \"icacls.exe $var /inheritance:r /grant:r $(setstr $grantuser) /remove:g $(setstr $denyuser) /deny $(setstr $denyuser) /T /Q /C\""
eval $ps3;
}
echo "Listing files and folders in $directory"
ls $directory >>$file;
rdfile $file
directory="C:\\Windows\\System32\\"
echo "Listing files and folders in $directory"
lstaccfiles $file
rdfile $file
directory="C:\\Windows\\SysWOW64\\"
echo "Listing files and folders in $directory"
lstaccfiles $file
rdfile $file
