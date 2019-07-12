#!/bin/bash

rm -rf /tmp/customer
ENV=$1
CHECKS=0
DEFS=0
echo "\n" >&2
git clone https://github.com/danielschlieder/customer.git /tmp/customer >/dev/null 2>&1
PENV="/tmp/customer/$ENV"
if [[ -e "$PENV" ]]; then
	echo "###############################################################################" >&2
	echo "Found checks supplied by the customer for environment $ENV" >&2
	echo "###############################################################################" >&2
	if [[ -e "$PENV/checks" ]]; then
		echo "-------------------------------------------------------" >&2
		echo "Copying checks" >&2
		echo "-------------------------------------------------------" >&2
		cp -arv $PENV/checks/* /usr/lib/nagios/plugins
		CHECKS=1
	fi 
	if [[ -e "$PENV/defs" ]]; then
		echo "-------------------------------------------------------" >&2
		echo "Copying check definition" >&2
		echo "-------------------------------------------------------" >&2
		mkdir -p /usr/share/icinga2/include/plugins-$ENV
		cp -arv $PENV/defs/* /usr/share/icinga2/include/plugins-$ENV
		echo "-------------------------------------------------------" >&2
		echo "Enabling new check definition" >&2
		echo "-------------------------------------------------------" >&2
		echo -e "include <plugins-$ENV>" >> /etc/icinga2/icinga2.conf
	else
		if [[ "$CHECKS" == "1" ]]; then
			echo "\nCustomer supplied checks without a definition! Please supply the definition in the /defs folder\n\n" >&2
			exit 1
		fi
	fi
	echo "###############################################################################" >&2
	echo "Processed checks supplied by the customer for environment $ENV" >&2
	echo "###############################################################################" >&2
fi 
echo "\n" >&2