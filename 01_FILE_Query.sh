#!/bin/ksh
echo "File extraction run has been initiated"
echo "=============================================================================="
file_path="/home/sit/files"
path_output="/home/sit/files/output"
cd /home/sit/files/output/
rm *.csv
rm *.sql
echo "===========================FILE_TYPE_1======================================"
for i in $file_path/SOURCE_FILE*.dat;
do
c=$(cat $i | awk -v RS="§" '/AVG_OUTSTANDING/{print NR;}')
g=$(cat $i | awk -v RS="§" '/IMPORT_SOURCE/{print NR;}')
e=$(cat $i | grep -- "-SMDW-" | awk -F '§' '{counts[$'$g']++;sums[$'$g'] += $'$c';} END { for (i in counts) printf("%s %s %0.1f\n", i, counts[i],sums[i]); ORS ="\n"}' | sort)
f=$(cat $i | grep -- "-WBDW-" | awk -F '§' '{counts[$'$g']++;sums[$'$g'] += $'$c';} END { for (i in counts) printf("%s %s %0.1f\n", i, counts[i],sums[i]); ORS ="\n"}' | sort)
m=$(cat $i | grep -- "-FML-" | awk -F '§' '{counts[$'$g']++;sums[$'$g'] += $'$c';} END { for (i in counts) printf("%s %s %0.1f\n", i, counts[i],sums[i]); ORS ="\n"}' | sort)
SUBSTRING=$(echo $i| rev | cut -d'/' -f 1 | rev)
echo $SUBSTRING >> X_FileName_FILE.csv
h=$(printf '%s|' $e)
j=$(printf '%s|' $f)
n=$(printf '%s|' $m)
sme1=$(echo $h | cut -d'|' -f1)
sme2=$(echo $h | cut -d'|' -f2)
sme3=$(echo $h | cut -d'|' -f3)
wb1=$(echo $j | cut -d'|' -f1)
wb2=$(echo $j | cut -d'|' -f2)
wb3=$(echo $j | cut -d'|' -f3)
fml1=$(echo $n | cut -d'|' -f1)
fml2=$(echo $n | cut -d'|' -f2)
fml3=$(echo $n | cut -d'|' -f3)
if [[ $sme1 != "" ]]; then
echo $sme1"|"$sme2"|"$sme3 >> RESULT_FILE.csv
fi
if [[ $wb1 != "" ]]; then
echo $wb1"|"$wb2"|"$wb3 >> RESULT_FILE.csv
fi
if [[ $fml1 != "" ]]; then
echo $fml1"|"$fml2"|"$fml3 >> RESULT_FILE.csv
fi
fname=$(echo $SUBSTRING | cut -d'.' -f1)
done
#############writing queries to param file############################
awk -F '|' '{print $1}' RESULT_FILE.csv | sed "s/^/select import_source||'|'||count(1)||'|'||sum(round(nvl(avg_outstanding,0),1)) AVG_OUTSTANDING from TABLE_NAME where import_source in('/;s/$/') group by import_source order by import_source;/" > RESULT_FILE_Param.sql
#############writing spool file name to param file############################
sed -i -e '1i\'"set newpage none\nset verify off\nset heading off\nset colsep '|'\nset linesize 300\nSET UNDERLINE OFF\nset feedback off\nset termout off\nset trimout on\nset tab off\ncolumn AVG_OUTSTANDING format 9999999999999999.99;\ncall pkg_rapm_context.set_period('&1');\nspool AVG_BAL_DB.csv append" -e '$ a\'"spool off;" RESULT_FILE_Param.sql>> RESULT_FILE_Param.sql
#############process X_FileName_FILE.csv file############################
sed -i 's/.dat//' X_FileName_FILE.csv
sed -i "/*/d" X_FileName_FILE.csv
sort -o X_FileName_FILE.csv X_FileName_FILE.csv
awk -F '|' '{print $1}' X_FileName_FILE.csv X_FileName_FILE.csv
sed "s/^/select data_source_code from FILE_CONFIG_TABLE where data_source_code in ('/;s/$/') order by data_source_code;/" X_FileName_FILE.csv >> FileName_FILE_Param.sql
sed -i -e '1i\'"set newpage none\nset verify off\nset heading off\nset colsep '|'\nset linesize 300\nSET UNDERLINE OFF\nset feedback off\nset termout off\nset trimout on\nset tab off\ncall pkg_rapm_context.set_period('&1');\nspool X_FileName_DB.csv append" -e '$ a\'"spool off;" FileName_FILE_Param.sql>> FileName_FILE_Param.sql
find . -maxdepth 1 -size 0c -exec rm {} \;
