# GITHUB REPO: https://github.com/independentcod/rdp-takeown-icacls
# -
# This bash script will configure Windows to allow and deny two different person on the computer from accessing/executing important windows system files.
# This is generally a safe task to do.
############
#  CONFIG  #
############
file="list.txt"
directory="C:\\Windows\\System32\\"
denyuser="ADMIN"
grantuser="Administrator"
quote='"'
rpar=")"
lpar="("
d2=":"
############
# Clearing old used files.
rm $file;
rm Commandstorun.log;
# Listing files and folders in directory and storing into file
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
