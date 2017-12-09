# AutoOffsiteBackup
A solution to automatically offsite-backup your local NAS backup (e.g. Time Machine backups).

## Top Level Requirements
* Automatic
* Safe
* Robust
* Ressource aware

## Derived Requirements
* Reading the system state shall be atomic
* Writing the system state shall be atomic
* Only deltas shall be transfered over WAN

## Assumptions/System Requirements
* Solution can execute code on local NAS and remote storage (e.g. two Synology Diskstations with ssh-access)
* Remote storage can run rsync
* Local NAS provides file system based snapshot functionality (e.g. btrfs)
* The onsite backup can simply be replicated, no need to select/filter files or to provide version management. (This shall be provided by the first tier backup solution, e.g. Time Machine, if needed.)
