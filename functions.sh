#GLOBAL VARIABLES

ADDRESS_STORE=./address-book-store

export ADDRESS_STORE

display_menu()
{
	echo "\nCOMMANDS"
	echo "\tadd"
	echo "\tsearch"
	echo "\tsearch all"
	echo "\tedit"
	echo "\tremove"
	echo "\texit"
}

verify_field_name()
{	
	if [ $1 != "Name" ] && [ $1 != "Surname" ] && [ $1 != "Email" ] && [ $1 != "Phone" ]; then
		echo "Invalid field name."
                return 2
	else
		return 0
        fi



}

confirm()
{
	METHOD=$1
	echo "CONFIRMATION: Do you want to ${METHOD}? (yes/no)"
	read ANS
	if [ "${ANS}" = "yes" ]; then
		return 0
	elif [ "${ANS}" = "no" ]; then
		return 1
	else
		echo "Invalid answer!"
		return 2
	fi
}

add_record()
{
	echo "You will be prompted for four params: Name, Surname, Email and Phone."
	echo -n "Name: "
	read NAME
	echo -n "Surname: "
	read SURNAME
	echo -n "Email: "
	read EMAIL
	echo -n "Phone: "
	read PHONE

	confirm "add"
	
	if [ $? -eq "0" ]; then
		CREATED_AT=`date`
		echo "Name: ${NAME} - Surname: ${SURNAME} - Email: ${EMAIL} - Phone: ${PHONE} - Created at: ${CREATED_AT}\n" >> ${ADDRESS_STORE}
		echo "\nValues inserted with success!\n"
	else
		echo "The user typed 'no'"
	fi

}


search_record()
{
	echo "You will be prompted for two params: Field name and Field value."
	echo -n "Field name: "
	read FIELD_NAME
	echo -n "Field value: "
	read FIELD_VALUE

	case ${FIELD_NAME} in 
		Name)
			grep -i -A 4 -e "Name: ${FIELD_VALUE}" ${ADDRESS_STORE}
			;;
		Surname)
			grep -i -A 2 -B 1 -e "Surname: ${FIELD_VALUE}" ${ADDRESS_STORE}
			;;
		Email)
			grep -i -A 1 -B -e "Email: ${FIELD_VALUE}" ${ADDRESS_STORE}
			;;
		Phone)
			grep -i -B 3 -e "Phone: ${FIELD_VALUE}" ${ADDRESS_STORE}
			;;
		*)
			echo "Please, type a valid field name: Name, Surname, Email or Phone.\n"
			return 2
			;;
	esac

}

remove_record()
{
	echo "You will be prompted for two params: Field name and Field Value. \nValid field name values: Name, Surname, Email and Phone."
	echo -n "Field name: "
	read FIELD_NAME
	echo -n "Field value: "
	read FIELD_VALUE

	verify_field_name ${FIELD_NAME}
	
	if [ $? -eq "2" ]; then
		return
	fi

	confirm "remove"

	if [ $? -eq "0" ]; then 
		grep -v "${FIELD_NAME}: ${FIELD_VALUE}" ${ADDRESS_STORE} > ${ADDRESS_STORE}.tmp
		mv ${ADDRESS_STORE}.tmp ${ADDRESS_STORE}
	else
		echo "Not removing..."
	fi
	
}

edit_record()
{
	echo -n "Field name: "
	read FIELD_NAME
	echo -n "Old field value: "
	read NAME
	
	verify_field_name ${FIELD_NAME}

	if [ $? -eq "2" ]; then
		return
	fi

	MATCHES_COUNT=`grep -c "${FIELD_NAME}: ${NAME}" ${ADDRESS_STORE}`
	
	if [ ${MATCHES_COUNT} -eq "0" ]; then
		echo "Field value does not found"	
		return
	fi
	
	grep -v "${FIELD_NAME}: ${NAME}" ${ADDRESS_STORE} > ${ADDRESS_STORE}.tmp
	mv ${ADDRESS_STORE}.tmp ${ADDRESS_STORE}

	echo -n "New name value: "
	read NAME
	echo -n "New surname value: "
	read SURNAME
	echo -n "New email value: "
	read EMAIL
	echo -n "New phone value: "
	read PHONE

	confirm "edit"

	if [ $? -eq "0" ]; then 
		echo "Name: ${NAME} - Surname: ${SURNAME} - Email: ${EMAIL} - Phone: ${PHONE} - Created at: `date`" >> ${ADDRESS_STORE}
	else
		echo "Not editing..."
	fi
}
