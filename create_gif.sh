#!/bin/bash

#  Parameters.
DIR=$1
GIFFILE=$2
GIFFILE=$GIFFILE.gif
TMP_FOLDER=tmp_gif_folder
EXT=".jpg"


#  Setup.
cd ${DIR}
DIR=`pwd`
echo ${DIR}
rm -fr ${TMP_FOLDER}
mkdir ${TMP_FOLDER}
cp `ls *${EXT} | awk '{nr++; if (nr % 25 == 0) print $0}'` ${TMP_FOLDER}/
cd ${TMP_FOLDER}

# Create .gif
convert -delay 40 -loop 0 *${EXT} ${GIFFILE}
mv ${GIFFILE} ${DIR}/

# Clean-up.
cd ${DIR}
rm ${TMP_FOLDER} -r
