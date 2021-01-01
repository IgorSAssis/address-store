#!/bin/sh

. ./functions.sh

if [ ! -f ${ADDRESS_STORE} ]; then
	echo "Creating a address-store file..."
	touch ${ADDRESS_STORE}
fi
	
if [ ! -r ${ADDRESS_STORE} ]; then
	echo "ERROR: address-book-store is not readable..."
	exit 1
fi

if [ ! -w ${ADDRESS_STORE} ]; then
	echo "ERROR: address-book-store is not writeable..."
	exit 2
fi


while :
do
	display_menu
	echo -n "--> "
	read COMMAND

	case ${COMMAND} in
		add)
			add_record
			continue
			;;
		search)
			search_record
			continue
			;;
		"search all")
			cat ${ADDRESS_STORE}
			continue
			;;
		remove)
			remove_record
			continue
			;;
		edit)
			edit_record
			continue
			;;
		exit)
			break
			;;
	esac

done

