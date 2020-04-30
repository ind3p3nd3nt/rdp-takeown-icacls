# GITHUB REPO: https://github.com/independentcod/rdp-takeown-icacls
# -
# This bash script will configure Windows to reset ACL configurations.
# This is just in case you or someone else screw things up.
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
# Backing up old files.
mv $file $file.bak;
mv Commandstorun.log Commandstorun.log.bak;
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
# Taking owner ship of the file/directory
ps1="takeown.exe /D Y /A /R /F $dirstring"
# reset permissions to all
ps2="icacls.exe $dirstring /setowner $grantuser /T /Q /C"
ps3="icacls.exe $dirstring /reset /T /Q /C"
# Write commands into log file.
echo $ps1 >>Commandstorun.log;
echo $ps2 >>Commandstorun.log;
echo $ps3 >>Commandstorun.log;
done <"$file"
# Display commands.
cat Commandstorun.log;
# Ask for confirm to run the script
read -p 'If this looks OK, you may want to execute now? (Y)' choice
case $choice in
 Y) sh Commandstorun.log && echo 'I hope it was not too hard ;o)';
esac
