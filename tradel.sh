#!/bin/sh

# the folder to move completed downloads to

# port, username, password
SERVER="9091 --auth transmission:transmission"

# use transmission-remote to get torrent list from transmission-remote list
# use sed to delete first / last line of output, and remove leading spaces
# use cut to get first field from each line
TORRENTLIST=`transmission-remote $SERVER --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=" " --fields=1`

transmission-remote $SERVER --list 

# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
    echo Processing : $TORRENTID 

    # check if torrent download is completed
    DL_COMPLETED=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "Percent Done: 100%"`

    # check torrents current state is
    STATE_STOPPED=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "State: Seeding\|Stopped\|Finished\|Idle"`
    echo $STATE_STOPPED

    # if the torrent is "Stopped", "Finished", or "Idle after downloading 100%"
    if ["$DL_COMPLETED"] && ["$STATE_STOPPED"]; then
        # move the files and remove the torrent from Transmission
        echo "Torrent #$TORRENTID is completed"
        echo "Removing torrent from list"
        transmission-remote $SERVER --torrent $TORRENTID --remove
    else
        echo "Torrent #$TORRENTID is not completed. Ignoring."
    fi
done
