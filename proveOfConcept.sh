#!/bin/sh

# MIT License - see https://github.com/TomTonic/AutoOffsiteBackup/blob/master/LICENSE

# Callit a spike, call it a hack - this is only the first prove of concept
# DO NOT USE for operational purposes



# script must be run as root for btrfs snapshots
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
  exit
fi


# config

srcdir="/volume1/Time Machine Folder"
dstdir="/volume1/rsync/TimeMachine"
usrsrv="name_o_user@remote_server"
waitforstabilization="60s"

# wait until directory is stable and take a snapshot

dirchksumcmd="find "'"'"$srcdir"'"'" -printf "'"'"%C@%p"'"'" | md5sum -"

echo "Checking directory "'"'"$srcdir"'"'" for stability..."

dirchksumval=`eval "$dirchksumcmd"`
echo "Directory checksum: $dirchksumval sleeping $waitforstabilization..."
sleep $waitforstabilization

dirchksumnew=`eval "$dirchksumcmd"`

while [ "$dirchksumval" != "$dirchksumnew" ]; do
    dirchksumval=$dirchksumnew
    echo "Directory checksum: $dirchksumval sleeping $waitforstabilization..."
    sleep $waitforstabilization
    dirchksumnew=`eval "$dirchksumcmd"`
done

echo "Ok, directory is stable."

date=`date "+%Y-%m-%dT%H_%M_%S"`
snapshotname="$srcdir/@backup-$date"
btrfs subvolume snapshot "$srcdir" "$snapshotname"


# do the backup
currentlnk="$dstdir/current"
intermediatepath="$dstdir/incomplete_back-$date"
finalpath="$dstdir/back-$date"

# the following statements cannot be executet in sudo context so run them as another user
sudo -u admin bash << ENDOFADMINCODE
rsync -azP \
  --delete \
  --delete-excluded \
  --exclude="@eaDir" \
  --link-dest="$currentlnk" \
  "$snapshotname/" "$usrsrv":"$intermediatepath" \
&& \
  ssh "$usrsrv" \
	"mv "'"'"$intermediatepath"'" "'"$finalpath"'"'" \
	&& rm -f "'"'"$currentlnk"'"'" \
	&& ln -s "'"'"$finalpath"'" "'"$currentlnk"'"' 
ENDOFADMINCODE

# remove the snapshot
btrfs subvolume delete "$snapshotname"

echo "Done."
