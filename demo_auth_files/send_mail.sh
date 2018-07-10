#!/bin/bash
# UTF-8
# =============================================================================
#         FILE: send_mail.sh
#  DESCRIPTION:
#        USAGE:
#      OPTIONS:
# REQUIREMENTS:
#
#      LICENCE:
#
#         BUGS:
#        NOTES:
#       AUTHOR: Jiří Tumpach (tumpji),
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 2018 07.08.
# =============================================================================

mailx -s "$1" -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login -S smtp=smtp://TODO -S from="TODO" -S smtp-auth-user=TODO -S smtp-auth-password="TODO" -S ssl-verify=ignore -S nss-config-dir=~/.certs -a "$2" -a "$3" TODO
