#!/bin/bash
# UTF-8
# =============================================================================
#         FILE: get_site.sh
#  DESCRIPTION: Script loads all web links from sites.txt. 
#               It writes output to $1/${index of link}.html and .log 
#        USAGE: start 
#      OPTIONS: 1 parameter - folder to download to
# REQUIREMENTS: bash
#
#      LICENCE:
#
#         BUGS:
#        NOTES:
#       AUTHOR: Jiří Tumpach (tumpji),
#      VERSION: 1.0
#      CREATED: 2018 07.08.
# =============================================================================

if [ $# -ne 1 ]
then
    echo "Ilegal number of parameters, you must provide folder"
    exit 1
fi

# actual index of site
index_site=1
# output folder
folder="$1"
# temporary file
temp_file=$(mktemp)


last_filter=""

# for each website
cat auth_secret_folder/sites.txt | while read line 
do
    if [ -n "$line" -a "${line:0:1}" == "#" ] 
    then
        last_filter="${line:1}"
    elif [ -n "$line" ]
    then
        # download site
        wget "$line" -vo "$folder/$index_site.log" -O $temp_file 
        output_file="$folder/$index_site.html"

        # optional filtering with specific script
        if [ -n "$last_filter" ]
        then
            # filter site 
            #echo "Filtering...$last_filter $output_file" 
            cat $temp_file | eval "$last_filter $output_file"
        else
            mv $temp_file $output_file
        fi

        # prepare for next site
        index_site=$(($index_site+1))
        last_filter=""
    fi
done
