DATA_DIR=$1

EXE=~/MarsFramework/MARSFramework/build/jni/libraries/EyeMARS/EyeMARSTester/./EyeMARS_test_undistort_dataset
CONFIG=${DATA_DIR}/mars_config.txt
IMAGE_DIR=${DATA_DIR}/dump/feature_tracking_primary/
OUT_DIR=${DATA_DIR}/dump/undistorted

mkdir -p $OUT_DIR

${EXE} ${CONFIG} ${IMAGE_DIR} ${OUT_DIR}
