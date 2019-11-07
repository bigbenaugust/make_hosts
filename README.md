# make_hosts
This is a shell script to backup/manage/restore/add stuff to your hosts file. I stole the idea from AdAway for Android. 

Usage: sudo make_hosts.sh (-b|-g|-r|-p)

* -b : Backup hosts file for future restoration
* -g : Generate ad blocking hosts file
* -r : Restore original hosts file in case stuff goes sideways
* -p : Returns to previous hosts file in case stuff goes sideways
    
Run with -b first to save your initial/original hosts file.

On some systemd machines, /etc/resolvconf/resolv.conf.d/head could be used instead of /etc/hosts. 

Really, something like: https://github.com/anticapitalista/antiX-live/blob/master/block-advert.sh is a lot prettier and does the same sort of thing.  
