PATH=/opt/wring/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#sender should be configured

sendAlert=0
todolist="todo.list"

echo "To: olivier.garcia84@gmail.com" > $todolist 
echo "From: Secretariat de M. Garcia <alertes@ogarcia.fr>" >>  $todolist
echo "Subject: Rapport d'activite de veille" >>  $todolist
echo "Content-Type: text/text; charset=utf-8" >>  $todolist



function letsGetSomeContent 
{
#$1 = URL
#$2 = DOM to retrieve
#$3 = file to compare
#$4 = Site name

#echo "Test de $3 '$2'"
wring text $1 "$2" > tmp_$3

#si on récupère bien qq chose
if [ -s tmp_$3 ]
then
diff tmp_$3 $3 > diff.txt

	if [ -s diff.txt ]
	then
 	echo "Nouvelles offres d'emploi $3 $1 :" >>  $todolist
 	cat diff.txt  >>  $todolist
	echo "-----------------------"  >>  $todolist
	echo "-----------------------"  >>  $todolist
	sendAlert=1
	fi
rm $3
mv tmp_$3 $3
rm diff.txt
else
rm tmp_$3
echo "$(date +'%Y%m%d %T') - nothing found for $3" >> veilleErreur.log
fi
}  


# LISTE DES SITES

# ETAT
letsGetSomeContent 'WebsiteURL' 'DOM' 'FILE'

#------------------------------------------------
#DO NOT TOUCH HERE
#-----------------------




#EMAIL ALERT

if [ "$sendAlert" -eq "1" ]; then
   #echo "OK ON ENVOI LE MAIL"
   cat $todolist | msmtp YOUREMAIL ADRESS
fi



#FINALY DELETING TODO LIST
rm $todolist

