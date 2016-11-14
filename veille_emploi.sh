
todolist="/home/olivier/Documents/emploi/todo.list"
emailcontent="Voici les nouvelles offres"
sendAlert=0

echo "To: olivier.garcia84@gmail.com" > $todolist 
echo "From: Secrétariat de M. Garcia <alertes@ogarcia.fr>" >> $todolist
echo "Subject: Rapport d'activité de veille" >> $todolist
echo "Content-Type: text/text; charset=utf-8" >> $todolist


# --------------- SITE DE l'ETAT -----------------------

url_a_parser='http://ge.ch/etat-employeur/places-vacantes'
file_compare="etat.txt"
echo "visite du site de l'etat"
wring text  $url_a_parser '.offre >  h4 > a'   > tmp_$file_compare
diff $file_compare tmp_$file_compare > diff.txt
if [ -s diff.txt ]
then
 echo "Nouvelles offres d'emploi à l'Etat :" >> $todolist
 cat diff.txt >> $todolist 
 

 echo "-----------------------" >> $todolist 
sendAlert="1"
fi
rm $file_compare
mv tmp_$file_compare $file_compare
rm diff.txt


# --------------- ALLTITUDE -----------------------
echo "alltitude"
url_a_parser='http://www.alltitude.com/openpositions'
file_compare="alltitude.txt"

wring text  $url_a_parser '.opp_title'   > tmp_$file_compare
diff $file_compare tmp_$file_compare > diff.txt
if [ -s diff.txt ]
then
  echo "Nouvelles offres d'emploi à ALLTITUDE :" >> $todolist
 cat diff.txt >> $todolist
	sendAlert="1"
fi
rm $file_compare
mv tmp_$file_compare $file_compare
rm diff.txt

#EMAIL ALERT

if [ "$sendAlert" = "1" ]; then
   cat $todolist | msmtp olivier.garcia84@gmail.com
fi

#jobup
#url_a_parser='http://www.jobup.ch/b2c/USR_joblist.asp?cmd=showresults&subcategories=,28,52,62,79,205,199,13,197,42,71,1,198,88,196,20,60,&cantons=GE1,GE2,GE3,VD1,GE&companytypes=0&jobmailerid=870343#1/1273857'
#file_compare="jobup.txt"
#wring text  $url_a_parser '#jobs_list .C_URL'   > tmp_$file_compare

