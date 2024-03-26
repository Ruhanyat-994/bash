#!/bin/bash
TODAY=$(date)
echo "The time for the scan is $TODAY"
DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
echo "Creating a Directory $DIRECTORY"
mkdir $DIRECTORY
if [ $2 == "nmap" ]
then
        nmap $DOMAIN > $DIRECTORY/nmap
elif [ $2 == "dirsearch" ]
then
        dirsearch -u $DOMAIN -e php > $DIRECTORY/dirsearch
else
        nmap $DOMAIN > $DIRECTORY/nmap
        echo "The results of nmap is stored in $DIRECTORY/nmap"
        dirsearch -u $DOMAIN -e php > $DIRECTORY/dirsearch
        echo "The results of dirsearch is stored in $DIRECTORY/dirsearch"
fi
