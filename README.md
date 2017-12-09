# AutoOffsiteBackup
A solution to automatically offsite-backup your local NAS backup.

## Use Cases
* As a user, I want to simply backup my Mac to my local NAS with Time Machine, not more.
* As a user, I want an offsite backup of my Time Machine backup for desaster recovery (fire, water, theft, etc.).
* As a user, I want a simple recovery of my data from the offsite backup in case I need it (because I probably care for other things in that situation as well...).
* As a user, I want to regularely backup all my photos and family videos (>1 TB, >150.000 files) to the remote location.
* As a user, I don't want my notebook to handle all this remote-backup stuff. I want my NAS to do all the work in the backgrund.
* As an administrator, I want the backup to run automatically.
* As an administrator, I want automatic security updates for all involved systems.
* As relative, I want easy access to the backuped data in case of a fatal desaster.

## Top Level Requirements (in the order of their priority)
1 Automatic
2 Safe and Robust
3 Performant and ressource aware
4 Platform independent

## Derived Requirements
* Interrupted transmissions shall not render the second tier backup inconsistent (Reading the system state shall be atomic)
* Changes on the first tier during backup to the second tier shall not render the backup on the second tier inconsistent (Writing the system state shall be atomic)
* Only deltas shall be transfered over WAN
* The solution shall be standards-based to the greatest possible extend.
* No need to patch the components

## Assumptions/System Requirements/Restrictions
* Solution can execute code on local NAS and remote storage (e.g. two Synology Diskstations with ssh-access)
* Local and remote storage can run rsync
* Local NAS provides file system based snapshot functionality (e.g. btrfs)
* Remote storage support hard-links
* The onsite backup can simply be replicated, no need to select/filter files or to provide version management. (This shall be provided by the first tier backup solution, e.g. Time Machine, if needed.)
* The backup process

## System Design
* bash script with standard tools (Linux-environment)
* simple and standard file structure of the second tier backup
* Automatic detection of activity in a target backup folder (e.g. is Time Machine currently running?)
* Local snapshot via btrfs before transmission (any alternatives?)
* rsync --link-dest for data transmission
* remove second tier backups after succesful transmission
* remove local snapshot
