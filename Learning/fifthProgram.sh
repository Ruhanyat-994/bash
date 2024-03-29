
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

echo "+++++++++++++Generating recon report from the output file+++++++++++++"
TODAY=$(date)
echo "This scan was created on $TODAY" > $DIRECTORY/report

grep -E "^\s*\S+\s+\S+\s+\S+\s*$" $DIRECTORY/nmap >> $DIRECTORY/report

echo "The results for dirsearch:" >> $DIRECTORY/report
echo "Results for crt.sh:" >> $DIRECTORY/report

jq -r ".[] | .name_value" $DIRECTORY/crt >>  $DIRECTORY/report







