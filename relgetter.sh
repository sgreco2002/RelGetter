# 2016 Accenture : sergio.greco
# release extractor for CenturyLink

DATETIME=$(date +"%Y-%m-%d_%H-%M")
FILENAME=extraction_$DATETIME.html
HEADER=`cat ./htmls/header.html`
FOOTER=`cat ./htmls/footer.html`
readarray SRVLIST < /home/nagios/relgetter/cfg/server.list
echo $HEADER >> $PWD/output/$FILENAME
for ITERATOR in ${SRVLIST[@]}; do
        IFS=# read TAG IP USR PASS <<< "$ITERATOR"
	./askremote.sh 22 $USR $PASS $IP /home/$USR/relextractor/./relextractor.sh | grep -v password > ./tmp/pre.txt
	sed 's/ //g' ./tmp/pre.txt > ./tmp/post.txt
	readarray INPUT < "./tmp/post.txt"
 	for ITERATOR2 in ${INPUT[@]}; do
		IFS=# read SRV REL <<< "$ITERATOR2" 
		if [[ ${SRV} != *"cannot"* ]]; then
			printf "<tr>" >> $PWD/output/$FILENAME
                	printf "<td>$TAG</td>" >> $PWD/output/$FILENAME
                	printf "<td>$IP</td>" >> $PWD/output/$FILENAME
			printf "<td>$SRV</td>" >> $PWD/output/$FILENAME
		       	printf "<td>$REL</td>" >> $PWD/output/$FILENAME
                	printf "</tr>" >> $PWD/output/$FILENAME
		else
			printf "<tr>" >> $PWD/output/$FILENAME
                        printf "<td>$TAG</td>" >> $PWD/output/$FILENAME
                        printf "<td>$IP</td>" >> $PWD/output/$FILENAME
                        printf "<td>Not Found</td>" >> $PWD/output/$FILENAME
                        printf "<td></td>" >> $PWD/output/$FILENAME
                        printf "</tr>" >> $PWD/output/$FILENAME
		fi
	done

done
echo $FOOTER >> $PWD/output/$FILENAME

CMD=`./mailsender.sh $PWD/output/$FILENAME`
exit 0
