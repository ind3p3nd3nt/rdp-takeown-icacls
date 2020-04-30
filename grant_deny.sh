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
file="list.txt"
directory="C:\\USERS\\Administrator\\"
denyuser="ADMIN"
grantuser="Administrator"
quote='"'
rpar=")"
lpar="("
d2=":"
############
# Backing up old files.
mv $file $file.bak;
mv Commandstorun.log Commandstorun.log.bak;
# Listing files and folders in directory and storing into file
ls $directory >$file;
#s32="ON"
if [[ $s32 = ON ]]; then
directory="C:\\Windows\\System32\\"
ls $directory | grep script >>$file;
ls $directory | grep .vbs >>$file;
ls $directory | grep admin >>$file;
ls $directory | grep powershell >>$file;
ls $directory | grep cmd >>$file;
ls $directory | grep net >>$file;
ls $directory | grep reg >>$file;
ls $directory | grep del >>$file;
ls $directory | grep mv >>$file;
ls $directory | grep run >>$file;
ls $directory | grep ip >>$file;
ls $directory | grep format >>$file;
ls $directory | grep .msc >>$file;
fi
#s64="ON"
if [[ $s64 = ON ]]; then
directory="C:\\Windows\\SysWOW64\\"
ls $directory | grep script >>$file;
ls $directory | grep .vbs >>$file;
ls $directory | grep admin >>$file;
ls $directory | grep powershell >>$file;
ls $directory | grep cmd >>$file;
ls $directory | grep net >>$file;
ls $directory | grep reg >>$file;
ls $directory | grep del >>$file;
ls $directory | grep mv >>$file;
ls $directory | grep run >>$file;
ls $directory | grep ip >>$file;
ls $directory | grep format >>$file;
ls $directory | grep .msc >>$file;
fi

# Reading File begins.
while IFS= read -r line
do
# If line contains a file, use proper formatting.
if [[ "$line" == *"."* ]]; then
line="*$line*"
# Same thing goes if it is a directory.   
else
line="$line\\"
fi
# Setting up strings concatenations
dirstring="$quote"
dirstring+="$directory"
dirstring+="$line"
dirstring+="$quote"
targetdenyobjectstring="$quote$denyuser$d2$lpar"
targetdenyobjectstring+="OI"
targetdenyobjectstring+="$rpar$lpar"
targetdenyobjectstring+="CI"
targetdenyobjectstring+="$rpar$lpar"
targetdenyobjectstring+="F"
targetdenyobjectstring+="$rpar$quote"
targetgrantobjectstring="$quote$grantuser$d2$lpar"
targetgrantobjectstring+="OI"
targetgrantobjectstring+="$rpar$lpar"
targetgrantobjectstring+="CI"
targetgrantobjectstring+="$rpar$lpar"
targetgrantobjectstring+="F"
targetgrantobjectstring+="$rpar$quote"
denyuserstring="$quote$grantuser$d2$lpar"
denyuserstring+="RA,WA,X,F"
denyuserstring+="$rpar$quote"
grantuserstring="$quote$denyuser$d2$lpar"
grantuserstring+="RA,WA,X,F"
grantuserstring+="$rpar$quote"
# Taking owner ship of the file/directory
ps1="takeown.exe /D Y /A /R /F $dirstring"
# Giving Full permission to grantuser
ps2="icacls.exe $dirstring /setowner $grantuser /T /Q /C"
ps3="icacls.exe $dirstring /grant:r $targetgrantobjectstring /T /Q /C"
# Revoking other access
ps4="icacls.exe $dirstring /deny $denyuserstring $targetdenyobjectstring /T /Q /C"
ps5="icacls.exe $dirstring /inheritancelevel:e /remove:g $targetdenyobjectstring /T /Q /C"
# Write commands into log file.
echo $ps1 >>Commandstorun.log;
echo $ps2 >>Commandstorun.log;
echo $ps3 >>Commandstorun.log;
echo $ps4 >>Commandstorun.log;
echo $ps5 >>Commandstorun.log;
done <"$file"
# Display commands.
cat Commandstorun.log;
# Ask for confirm to run the script
read -p 'If this looks OK, you may want to execute now? (Y)' choice
case $choice in
 Y) sh Commandstorun.log && echo 'I hope it was not too hard ;o)';
esac
