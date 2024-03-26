#!/bin/bash
TODAY=$(date)
echo "This scan was created on $TODAY"
DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
echo "Creating directory $DIRECTORY."
mkdir $DIRECTORY
nmap $DOMAIN > $DIRECTORY/nmap
echo "The results of nmap is stored in $DIRECTORY/nmap"
dirsearch -u $DOMAIN -e php > $DIRECTORY/dirsearch
echo "The results of dirsearch is stored in $DIRECTORY/dirsearch"
