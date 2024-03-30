#!/bin/bash
source ./scan.lib
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
