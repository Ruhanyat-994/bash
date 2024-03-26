#!/bin/bash
echo "Creating directory $1_recon."
mkdir $1_recon;
nmap $1 > $1_recon/nmap
echo "The results of nmap scan are stored in $1_recon/namp"
dirsearch -u $1 -e php > $1_recon/dirsearch
echo "The results of dirsearch scan are stored in $1_recon/dirsearch."


