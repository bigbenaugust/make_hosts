#!/bin/bash
# make_hosts.sh - a script to make a ad-blocking hosts file ala AdAway
# for Android

case $1 in
  -b)
    # initial go, back up original hosts file
    echo "Backing up hosts file to /etc/hosts.initial"
    if [[ ! -e /etc/hosts.initial ]] ; then
      cp /etc/hosts /etc/hosts.initial
    echo "Done."
    else
      echo "Sorry, I will not overwrite an existing /etc/hosts.initial file"
      exit 1;
    fi
    ;;
  -g)
    # real deal
    echo "Backing up current hosts file to /etc/hosts.previous"
    cp /etc/hosts /etc/hosts.previous
    origlength=`wc -l /etc/hosts.previous | awk '{print $1}'`
    echo "Previous /etc/hosts file was $origlength lines"
    echo "Starting with a fresh hosts file"
    cp /etc/hosts.initial /tmp/hosts.initial
    echo "Downloading ad blocking hosts files"
    for i in https://adaway.org/hosts.txt http://winhelp2002.mvps.org/hosts.txt http://hosts-file.net/ad_servers.txt http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts\&showintro=0\&mimetype=plaintext https://www.malwaredomainlist.com/hostslist/hosts.txt https://mirror.cedia.org.ec/malwaredomains/justdomains ; do
    echo "  $i..."  
    curl -s $i | grep -v ^# | grep -v localhost.localdomain$ | grep -v localhost$i | awk '{print "127.0.0.1 " $2}' >> /tmp/adblocklist.txt
    done
    echo "including local file /etc/extraadhosts.txt (if present)"
    if [[ -e /etc/extraadhosts.txt ]] ; then
      cat /etc/extraadhosts.txt >> /tmp/adblocklist.txt
    fi
    echo "Processing... " 
    dos2unix /tmp/adblocklist.txt
    sort /tmp/adblocklist.txt  | uniq | sed '/^[[:space:]]*$/d;s/^127.0.0.1[[:space:]]*$//' > /tmp/adblocklist.sorted.txt
    cat /tmp/adblocklist.sorted.txt >> /tmp/hosts.initial    
    mv /tmp/hosts.initial /tmp/hosts.done
    # checking for changes before we apply anything
    if [[ x == x`diff -q /tmp/hosts.done /etc/hosts` ]] ; then
      echo "No differences found. Not continuing."
      exit 0;
    fi
    echo "The hosts files have changed. Updating."
    echo "Copying /tmp/hosts.done to /etc/hosts"
    mv /tmp/hosts.done /etc/hosts
    echo "Cleaning up"
    rm /tmp/adblocklist.txt
    newlength=`wc -l /etc/hosts | awk '{print $1}'`
    echo "The /etc/hosts file is now $newlength lines." 
    echo "Done."
    ;;
  -r) 
    # put it back! 
    echo "Restoring original hosts file."
    cp /etc/hosts.initial /etc/hosts
    echo "Done."
  ;;
  -p)
    # put back the previous one
    echo "Restoring previous hosts file."
    cp /etc/hosts.previous /etc/hosts
    echo "Done."
  ;;
  *)
    echo "Usage: sudo $0 (-b|-g|-r|-p)
     -b : Backup hosts file for future restoration (DO THIS FIRST)
     -g : Generate ad blocking hosts file
     -r : Restore original hosts file in case stuff goes sideways
     -p : Returns to previous hosts file in case stuff goes sideways
     Run with -b first to save your initial/original hosts file."
  ;;
esac
