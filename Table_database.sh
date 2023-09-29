cd HOME/SIT/File_vs_DB/
SERVICENAME1=$(head -5 $line Table_UserParams.dat | tail -1)
echo $SERVICENAME1
Schemaname1=$(head -6 $line Table_UserParams.dat | tail -1)
echo $Schemaname1
Password1=$(head -7 $line Table_UserParams.dat | tail -1)
echo $Password1
Pkey1=$(head -8 $line Table_UserParams.dat | tail -1)
echo $Pkey1

echo "DB extraction run has been initiated"

sqlplus $Schemaname1/$Password1@$SERVICENAME1 << EOF
whenever sqlerror exit sql.sqlcode;
set echo off
@sample.sql $Pkey1
exit;
EOF
