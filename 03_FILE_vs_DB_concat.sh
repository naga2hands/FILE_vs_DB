#!/bin/ksh
cd HOME/SIT/File_vs_DB/
rm Output_TBL_FileName.csv
rm Output_TBL_ImportSource.csv
echo "file vs. db run has been initiated"
echo "=============================================================================="
file_path="/home/sit/files"
path_output="/home/sit/files/output"
echo "===========================Files concat======================================"
echo "-----FILE_TYPE_1 Recon------" >> Output_TBL_ImportSource.csv
echo "IMPORT_SOURCE_FILE|COUNT|AVG_OUTSTANDING|IMPORT_SOURCE_DB|COUNT|AVG_OUTSTANDING" >> Output_TBL_ImportSource.csv
paste -d'|' $path_output/RESULT_FILE.csv $path_output/RESULT_DB.csv >> Output_TBL_ImportSource.csv
