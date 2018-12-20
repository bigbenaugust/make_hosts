# make_hosts
This is a shell script to backup/manage/restore/add stuff to your hosts file. I stole the idea from AdAway for Android. 

Usage: sudo make_hosts.sh (-b|-g|-r|-p)

* -b : Backup hosts file for future restoration
* -g : Generate ad blocking hosts file
* -r : Restore original hosts file in case stuff goes sideways
* -p : Returns to previous hosts file in case stuff goes sideways
    
Run with -b first to save your initial/original hosts file.
