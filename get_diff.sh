#!/bin/bash
# UTF-8
# =============================================================================
#         FILE: get_diff.sh
#  DESCRIPTION: 
#        USAGE: 
#      OPTIONS: reset -- first downdload of sites and 
#                        creating 'tmp' folder tree (do not checks for difference)
#               run   -- inf. run of this script (check every 20m)
#
# REQUIREMENTS: auth_secret_folder/ignore_list.txt  -- ignore file
#               auth_secret_folder/send_mail.sh     -- script that send file
#               auth_secret_folder/sites.txt        -- sites to check 
#                                                      [with '#' comments, ignore empty lines]
#
#      LICENCE:
#
#         BUGS:
#        NOTES:
#       AUTHOR: Jiří Tumpach (tumpji),
#      VERSION: 1.0
#      CREATED: 2018 07.08.
# =============================================================================

function execute_diff {
    # move contents of down1 to down2
    rm tmp/down2/* 2>/dev/null
    rm tmp/lastdiff/* 2>/dev/null

    mv tmp/down1/* tmp/down2

    # download to down1
    ./get_site.sh tmp/down1

    # check file by file
    for filepath in tmp/down1/*.html; do
        filename=${filepath##*/}
        fileindex=${filename%.html}

        diff -N -EZibwB "tmp/down1/$filename" "tmp/down2/$filename"  > "tmp/lastdiff/$fileindex"

        if [ -s "tmp/lastdiff/$fileindex" ]
        then
            # send email
            address=$(cat auth_secret_folder/sites.txt | sed '/^[ \t]*$/d' | sed '/^#.*$/d' | awk "NR == $fileindex" )
            subject="$(echo "$address" | sed 's:^\(https\?\://\)\?\(www.\)?::' | sed 's:/.*::') is changed"

            # make body of mail
            echo "Website $address is changed." > tmp/message.txt
            # send mail
            cat tmp/message.txt | ./auth_secret_folder/send_mail.sh "$subject" "tmp/lastdiff/$fileindex" "tmp/down1/$fileindex.log"
        fi
    done
}

function init_diff {
    # init (only if there is change in config files)
    echo "Downloading initial file"
    mkdir tmp  2>/dev/null
    mkdir tmp/down1 tmp/down2 tmp/lastdiff 2>/dev/null

    rm tmp/down1/* 2>/dev/null
    rm tmp/down2/* 2>/dev/null
    rm tmp/lastdiff 2>/dev/null

    ./get_site.sh tmp/down1
}

if [ "$1" == "reset" ]
then
    init_diff
elif [ "$1" == "run" ]
then
    while true 
    do
        execute_diff
        echo "Begin sleep ..."
        sleep 20m
        echo "End sleep ..."
        echo "check ..."
    done
fi

