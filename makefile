# UTF-8
# =============================================================================
#         FILE: makefile
#  DESCRIPTION: this project checks if site is changed 
#  				if yes then it sends email to you
#        USAGE: make all / make
#      OPTIONS: 
#              
# REQUIREMENTS: auth_secret_folder/send_mail.sh     -- script that sends mail to you
#               auth_secret_folder/sites.txt        -- sites to check
#               	#<script>                       -- indicates script (filter)
#
#      LICENCE: 
#         BUGS:
#        NOTES:
#       AUTHOR: Jiří Tumpach (tumpji),
#      VERSION: 1.0
#      CREATED: 2018 07.10.
# =============================================================================

.PHONY:all reset run

# download first version of site and then check every 20m for difference
all: reset run

# only download first version [debugging]
reset:
	./get_diff.sh reset

# only run periodic checking [debugging]
run:
	echo 'starting ...'
	./get_diff.sh run
