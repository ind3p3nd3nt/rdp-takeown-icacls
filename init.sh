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
directory="C:\\USERS\\Administrator"
denyuser="ADMIN"
grantuser="Administrator"
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
fi
# Same thing goes if it is a directory.   
if [[ "$line" == *"/"* ]]; then
line="$line\\*"
fi
# Taking owner ship of the file/directory
command="Invoke-Expression start /REALTIME takeown.exe /D Y /A /R /F $line*";
echo $command >>Commandstorun.log;
# Giving Full permission to grantuser
command="Invoke-Expression start /REALTIME icacls.exe $directory$line /GRANT $grantuser':(RA,WA,X,F)' /T" ;
echo $command >>Commandstorun.log;
# Make objects inherit.
command="Invoke-Expression start /REALTIME icacls.exe /inheritance:r $directory$line /GRANT $grantuser:'(OI)(CI)(F)' /T" ;
echo $command >>Commandstorun.log;
# Denying all permission to denyuser
command="Invoke-Expression start /REALTIME icacls.exe $directory$line /DENY $denyuser':(RA,WA,X,F)' /T" ;
echo $command >>Commandstorun.log;
# Make objects inherit
command="Invoke-Expression start /REALTIME icacls.exe /inheritance:r $directory$line /DENY $denyuser':(OI)(CI)(F)' /T" ;
echo $command >>Commandstorun.log;
done <"$file"
cat Commandstorun.log;
read -p 'If this looks of you may want to execute now? (Y)' choice
case $choice in
 Y) sh Commandstorun.log && echo 'I hope it was not too hard ;o)';
esac
