#  This script relies on calib_compare.sh
#  It us used to run the program multiple times.

#  $1 is the base data directory with the assumption that there are
#  multiple datasets in immediate subdirectories.

#  $2 is the max number of threads allowed.  My machine has 40 cores!
#  I set this to 30 with no problems.

#####  CALIB_COMPARE must be set for local machine.       <<<<<<<!!!!!!!!!

BASE_DIR=$1
NUM_THREADS=$2
CALIB_COMPARE="~/redwood_ws/scripts/calib_compare.sh"

echo "PID: $BASHPID"


DIR_FILE="directory_to_run.txt"
EXIT_CODE_FILE="exit_codes.txt"

# Clear files.
rm ${DIR_FILE} 2> /dev/null
rm ${EXIT_CODE_FILE} 2> /dev/null

for DIR in `find ${BASE_DIR} -maxdepth 1 -type d`; do
  if [ "$SUB_DIR" == '.' ] || [ "$SUB_DIR" == ".." ]
  then
    continue
  fi
  echo $DIR >> ${DIR_FILE}
done

# Run programs.
# cat $COMMAND_FILE | xargs --max-procs=${NUM_THREADS} -n 3
parallel -j ${NUM_THREADS} ${CALIB_COMPARE} {} ${EXIT_CODE_FILE} ::: `cat ${DIR_FILE}`

cat ${EXIT_CODE_FILE}

# Cleanup
rm ${DIR_FILE} 2> /dev/null
rm ${EXIT_CODE_FILE} 2> /dev/null
echo FINISHED.
