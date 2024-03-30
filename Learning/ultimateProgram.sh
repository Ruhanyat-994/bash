#!/bin/bash

source ./scan.lib

while getopts "m:i" OPTION; do
    case $OPTION in
        m)
            MODE=$OPTARG
            ;;
        i)
            INTERACTIVE=true
            ;;
    esac
done

scan_domain() {
    DOMAIN=$1
    DIRECTORY=${DOMAIN}_recon

    echo "Creating a Directory $DIRECTORY"

    mkdir $DIRECTORY

    case $MODE in 
        nmap)
            nmap_scan $DOMAIN $DIRECTORY
            ;;
        dirsearch)
            dirsearch_scan $DOMAIN $DIRECTORY
            ;;
        crt)
            crt_scan $DOMAIN $DIRECTORY
            ;;
        *)
            nmap_scan $DOMAIN $DIRECTORY
            dirsearch_scan $DOMAIN $DIRECTORY
            crt_scan $DOMAIN $DIRECTORY
            ;;
    esac
}

report_domain() {
    DOMAIN=$1
    DIRECTORY=${DOMAIN}_recon

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
}

if [ $INTERACTIVE ]; then
    INPUT="BLANK"
    while [ "$INPUT" != "quit" ]; do
        echo "Please Enter a domain!"
        read INPUT
        if [ "$INPUT" != "quit" ]; then
            scan_domain "$INPUT"
            report_domain "$INPUT"
        fi
    done
else 
    for i; do
        scan_domain "$i"
        report_domain "$i"
    done
fi
