#!/usr/bin/ksh
#
###
# POEC - MSPR 
#   backup SQLite db
###

### STEP ###
# 1) Set the binary "sqlite3" to your PATH_BIN
# 2) Set your file name in PATH_TARGET_DUMP for all schema & data
# 3) Run this script in terminal / crontab: ksh backup_db.ksh 

# PATH_BIN=$PATH_BIN:/usr/bin/";
PATH_SOURCE=/home/tran/www/flask
PATH_TARGET_DUMP=/home/tran/www/dbbackup/export_all_mydb.sql";

##### DUMP ALL SCHEMA & DATA #####
sqlite3 $PATH_SOURCE .dump > $PATH_TARGET_DUMP;
echo "Done... Export all to: " $PATH_TARGET_DUMP;

echo "All Done !";
