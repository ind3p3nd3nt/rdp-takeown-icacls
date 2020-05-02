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
directory="C:\\USERS\\indep\\"
file="list.txt"
denyuser="ADMIN"
grantuser="indep"
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
# Reading File begins.
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
var+="$2*"
var+="$quote"
# Taking owner ship of the file/directory
ps1="takeown.exe /D Y /A /R /F $var"
# Giving Full permission to grantuser
ps2="icacls.exe $var /setowner $grantuser /T /Q /C"
ps3="icacls.exe $var /inheritance:r /grant:r $(setstr $grantuser) /remove:g $(setstr $denyuser) /deny:r $(setstr $denyuser) /T /Q /C"
# Write commands into log file.
echo $ps1 >>RunCommands.ps1;
echo $ps2 >>RunCommands.ps1;
echo $ps3 >>RunCommands.ps1;
############
# Backing up old files.
mv $file $file.bak;
mv RunCommands.ps1 RunCommands.ps1.bak;
# Listing files and folders in directory and storing into file
directory="C:\\Windows\\System32\\"
ls $directory >>$file;
rdfile $file
directory="C:\\Windows\\SysWOW64\\"
lstaccfiles $file
rdfile $file
# Display commands.
cat RunCommands.ps1;
start /REALTIME powershell RunCommands.ps1;
