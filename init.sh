# GITHUB REPO: https://github.com/independentcod/rdp-takeown-icacls
# -
# This bash script will configure Windows to allow and deny two different person on the computer from accessing/executing each others data.
# I had this idead when people were starting to screw with my remote desktop server.
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
# Clearing old used files.
rm $file;
rm Commandstorun.log;
# Listing files and folders in directory and storing into file
ls $directory >$file;
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
ps5="icacls.exe $dirstring /remove:g $targetdenyobjectstring /T /Q /C"
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
read -p 'If this looks of you may want to execute now? (Y)' choice
case $choice in
 Y) sh Commandstorun.log && echo 'I hope it was not too hard ;o)';
esac
