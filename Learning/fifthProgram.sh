#!/bin/bash

TODAY=$(date)
echo "The time for the scan is $TODAY"

nmap_scan() {
    nmap $DOMAIN > "$DIRECTORY/nmap"
    echo "The results of nmap are stored in $DIRECTORY/nmap"
}

dirsearch_scan() {
    dirsearch -u $DOMAIN -e php > "$DIRECTORY/dirsearch"
    echo "The results of dirsearch are stored in $DIRECTORY/dirsearch"
}

crt_scan() {
    curl "https://crt.sh/?q=$DOMAIN&output=json" -o "$DIRECTORY/crt"
    echo "The results of crt search are stored in $DIRECTORY/crt"
}

getopts "m:" OPTION
MODE=$OPTARG

for i; do
    DOMAIN=$i
    DIRECTORY="${DOMAIN}_recon"
    echo "Creating directory $DIRECTORY"
    mkdir -p "$DIRECTORY"

    case $MODE in 
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

    echo "+++++++++++++Generating recon report from the output file+++++++++++++"
    TODAY=$(date)
    echo "This scan was created on $TODAY" > "$DIRECTORY/report"

    if [ -f "$DIRECTORY/nmap" ]; then
        echo "Results for nmap:" >> "$DIRECTORY/report"
        grep -E "^\s*\S+\s+\S+\s+\S+\s*$" "$DIRECTORY/nmap" >> "$DIRECTORY/report"
    fi

    if [ -f "$DIRECTORY/dirsearch" ]; then
        echo "Results for dirsearch:" >> "$DIRECTORY/report"
        cat "$DIRECTORY/dirsearch" >> "$DIRECTORY/report"
    fi

    if [ -f "$DIRECTORY/crt" ]; then
        echo "Results for crt:" >> "$DIRECTORY/report"
        jq -r ".[] | .name_value" "$DIRECTORY/crt" >> "$DIRECTORY/report"
    fi
done
