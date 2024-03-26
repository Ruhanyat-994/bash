#!/bin/bash

TODAY=$(date)
echo "The time for the scan is $TODAY"

DOMAIN=$1
DIRECTORY=${DOMAIN}_recon

echo "Creating a Directory $DIRECTORY"
mkdir $DIRECTORY

nmap_scan()
{
         nmap $DOMAIN > $DIRECTORY/nmap
         echo "The results of nmap is stored in $DIRECTORY/nmap"
}

dirsearch_scan()
{
        dirsearch -u $DOMAIN -e php > $DIRECTORY/dirsearch
        echo "The results of dirsearch is stored in $DIRECTORY/dirsearch"

}
crt_scan()
{
        curl "https://crt.sh/?q=$DOMAIN&output=json" -o $DIRECTORY/crt
        echo "The results of crt search in stored in $DIRECTORY/crt"

}

case $2 in 
        nmap)
                nmap_scan
                ;;
        dirsearch)
                dirsearch_scan
                ;;
        crt)
                crt_scan
                ;;
        *)
                nmap_scan
                dirsearch_scan
                crt_scan
                ;;
esac
