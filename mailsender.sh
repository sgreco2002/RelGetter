RECEPIENT=`cat ./cfg/mail.list`
readarray MAIL < ./cfg/mail.txt
for ITERATOR in ${MAIL[@]}; do
	IFS=# read LBL VAL <<< $ITERATOR
	if [[ ${LBL} != *"subject*" ]]; then
		SUBJECT=$VAL
	else
		BODY=$VAL
	fi

done

CMD=`(
        echo "To: ${RECEPIENT}";
        echo "Subject: [CTL] Installation Status for environment DEVPLUS";
        echo "Content-Type: text/html";
        echo ;
        cat $1;
        ) | sendmail -t
`
