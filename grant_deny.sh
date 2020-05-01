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
s32="ON"
s64="ON"
denyuser="ADMIN"
grantuser="indep"
quote='"'
rpar=")"
lpar="("
d2=":"
# Setting up strings concatenations
targetdenyobjectstring="$quote$denyuser$d2$lpar"
targetdenyobjectstring+="RA"
targetdenyobjectstring+=","
targetdenyobjectstring+="WA"
targetdenyobjectstring+=","
targetdenyobjectstring+="X"
targetdenyobjectstring+="$rpar$quote"
targetgrantobjectstring="$quote$grantuser$d2$lpar"
targetgrantobjectstring+="RA"
targetgrantobjectstring+=","
tacrgetgrantobjectstring+="WA"
targetgrantobjectstring+=","
targetgrantobjectstring+="X"
targetgrantobjectstring+="$rpar$quote"
ccdenyuserstring="$quote$grantuser$d2$lpar"
denyuserstring+="RA,WA,X,F"
denyuserstring+="$rpar$quote"
grantuserstring="$quote$denyuser$d2$lpar"
grantuserstring+="RA,WA,X,F"
grantuserstring+="$rpar$quote"

function chk()
{
# If line contains a file, use proper formatting.
if [[ "$2" == *"."* ]]; then
line="$1"
line+="*$2*"
# Same thing goes if it is a directory.   
else
line="$l"
fi
# Taking owner ship of the file/directory
ps1="takeown.exe /D Y /A /R /F $1"
# Giving Full permission to grantuser
ps2="icacls.exe $1$2 /setowner $grantuser /T /Q /C"
ps3="icacls.exe $1$2 /inheritancelevel:r /grant $targetgrantobjectstring /T /Q /C"
# Revoking other access
ps4="icacls.exe $1$2 /deny $targetdenyobjectstring /T /Q /C"
ps5="icacls.exe $1$2 /remove:g $targetdenyobjectstring /T /Q /C"
# Write commands into log file.
echo $ps1 >>Commandstorun.log;
echo $ps2 >>Commandstorun.log;
echo $ps3 >>Commandstorun.log;
echo $ps4 >>Commandstorun.log;
echo $ps5 >>Commandstorun.log;
}
############
# Backing up old files.
mv $file $file.bak;
mv Commandstorun.log Commandstorun.log.bak;
# Listing files and folders in directory and storing into file
dirstring="$quote"
dirstring+="$directory"
dirstring+="$line"
ls $directory >>$file;
# Reading File begins.
while IFS= read -r line
do
chk $dirstring $line
done <"$file"
directory="C:\\Windows\\System32\\"
dirstring="$quote"
dirstring+="$directory"
dirstring+="$line"
ls $directory | grep script >>$file;
ls $directory | grep .vbs >>$file;
ls $directory | grep admin >>$file;
ls $directory | grep powershell >>$file;
ls $directory | grep .cmd >>$file;
ls $directory | grep net.exe >>$file;
ls $directory | grep reg. >>$file;
ls $directory | grep del. >>$file;
ls $directory | grep mv. >>$file;
ls $directory | grep run >>$file;
ls $directory | grep ipconfig >>$file;
ls $directory | grep format >>$file;
ls $directory | grep netstat >>$file;
ls $directory | grep .msc >>$file;
ls $directory | grep shutdown >>$file;
ls $directory | grep takeown >>$file;
ls $directory | grep icacls >>$file;
ls $directory | grep task >>$file;
# Reading File begins.
while IFS= read -r line
do
chk $dirstring $line
done <"$file"
directory="C:\\Windows\\SysWOW64\\"
dirstring="$quote"
dirstring+="$directory"
dirstring+="$line"
ls $directory | grep script >>$file;
ls $directory | grep .vbs >>$file;
ls $directory | grep admin >>$file;
ls $directory | grep powershell >>$file;
ls $directory | grep .cmd >>$file;
ls $directory | grep net.exe >>$file;
ls $directory | grep reg. >>$file;
ls $directory | grep del. >>$file;
ls $directory | grep mv. >>$file;
ls $directory | grep run >>$file;
ls $directory | grep ipconfig >>$file;
ls $directory | grep format >>$file;
ls $directory | grep netstat >>$file;
ls $directory | grep .msc >>$file;
ls $directory | grep shutdown >>$file;
ls $directory | grep takeown >>$file;
ls $directory | grep icacls >>$file;
ls $directory | grep task >>$file;
# Reading File begins.
while IFS= read -r line
do
chk $dirstring $line
done <"$file"
# Display commands.
cat Commandstorun.log;
# Ask for confirm to run the script
read -p 'Now paste these commands into a powershell as administrator.' choice
