#!/bin/bash
#
# Functions shared by several scripts
#


function detect_system {
# Determine distro title, release, codename
#
# Input: 
#   -/-
#
# Output:
#   No direct output, but the following variables are set:
#   lsb: whether (1) or not (0) system information was retrieved from 'lsb_release'
#   distribution: detected Linux distribution (string)
#   release: detected distribution release / version (string)
#   codename: codename of the detected Linux distribution (string)
#   architecture: detected machine architecture (string)

	if [[ `which lsb_release` = '' ]]
	then
		lsb=0
		if [ -e /etc/debian_version ]
		then 
			distribution='Debian'
			release='unknown release version'
			codename=`cat /etc/debian_version`
		elif [ -e /etc/SuSE-release ]
		then 
			distribution='SuSE'
			release='unknown release version'
			codename=`cat /etc/SuSE-release`
		elif [ -e /etc/redhat-release ]
		then
			if [ -e /etc/fedora-release ]
			then 
				distribution='Fedora'
				release='unknown release version'
				codename=`cat /etc/fedora-release`
			else 
				distribution='Redhat'
				release='unknown release version'
				codename=`cat /etc/redhat-release`
			fi
		elif [ -e /etc/fedora-release ]
		then 
			distribution='Fedora'
			release='unknown release version'
			codename=`cat /etc/fedora-release`
		elif [ -e /etc/mandrake-release ]
		then 
			distribution='Mandrake'
			release='unknown release version'
			codename=`cat /etc/mandrake-release`
		fi
	else
		lsb=1

		distribution=`lsb_release -i | awk -F':' '{ gsub(/^[ \t]*/,"",$2); print $2 }'`
		release=`lsb_release -r | awk -F':' '{ gsub(/^[  \t]*/,"",$2); print $2 }'`
		codename=`lsb_release -c | awk -F':' '{ gsub(/^[ \t]*/,"",$2); print $2 }'`

		# Some distribution examples:
		#
		# OpenSuSE 11.4
		#   LSB Version:    n/a
		#   Distributor ID: SUSE LINUX
		#   Description:    openSUSE 11.4 (x86_64)
		#   Release:        11.4
		#   Codename:       Celadon
		#
		# OpenSuSE 12.1
		#   LSB support:  1
		#   Distribution: SUSE LINUX
		#   Release:      12.1
		#   Codename:     Asparagus
		#
		# Arch
		#   LSB Version:    n/a
		#   Distributor ID: archlinux
		#   Description:    Arch Linux
		#   Release:        rolling
		#   Codename:       n/a
		#
		# Ubuntu 12.04
		#   Distributor ID: Ubuntu
		#   Description:    Ubuntu 12.04 LTS
		#   Release:        12.04
                #   Codename:       precise
	fi
	architecture=`uname -m`

}
