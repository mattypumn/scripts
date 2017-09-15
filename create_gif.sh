#  Parameters.
DIR=$1
TMP_FOLDER=tmp_gif_folder

#  Setup.
cd ${DIR}
DIR=`pwd`
echo ${DIR}
rm -fr ${TMP_FOLDER}
mkdir ${TMP_FOLDER}
cp `ls *.pgm | awk '{nr++; if (nr % 10 == 0) print $0}'` ${TMP_FOLDER}/
cd ${TMP_FOLDER}

# Create .gif
convert -delay 4 -loop 0 *.pgm animated.gif
mv animated.gif ${DIR}/

# Clean-up.
cd ${DIR}
rm ${TMP_FOLDER} -r
