#!/bin/bash
TODAY=$(date)
echo "The time for the scan is $TODAY"


DOMAIN=$1
DIRECTORY=${DOMAIN}_recon

echo "Creating a Directory $DIRECTORY"
mkdir $DIRECTORY

case $2 in
        nmap)
                nmap $DOMAIN > $DIRECTORY/nmap
                echo "The results of nmap is stored in $DIRECTORY/nmap"
                ;;
        dirsearch)
                dirsearch -u $DOMAIN -e php > $DIRECTORY/dirsearch
                echo "The results of dirsearch is stored in $DIRECTORY/dirsearch"
                ;;
        crt)
                curl "https://crt.sh/?q=$DOMAIN&output=json" -o $DIRECTORY/crt
                echo "The results of crt search in stored in $DIRECTORY/crt"
                ;;
        *)
                nmap $DOMAIN > $DIRECTORY/nmap
                echo "The results of nmap is stored in $DIRECTORY/nmap."
                dirsearch -u $DOMAIN -e php > $DIRECTORY/dirsearch
                echo "The results of dirsearch is stored in $DIRECTORY/dirsearch."
                curl " https://crt.sh/?q=$DOMAIN&output=json" -o $DIRECTORY/crt
                echo "The results of crt search in stored in $DIRECTORY/crt."
                ;;
esac
