DATA_DIR=$1
HEIGHT_DUMP_DIR=$2
DATA_NAME=$3
# DATA_DIR=/usr/local/google/home/mpoulter/for_matt/polaris_floor_vicon/mrinal/1
CALIB_DIR=${DATA_DIR}/calibration.xml
CAD_CALIB_DIR=${DATA_DIR}/cad-calibration.xml
ONLINE_CALIB_DIR=${DATA_DIR}/online-calibration.xml
HEIGHT_FILE=stable_height.txt
HEIGHT_STANDARD=stable_height_no-module.txt
HEIGHT_MODULE=stable_height_with-module.txt
OUTPUT_DIR=${HEIGHT_DUMP_DIR}/${DATA_NAME}
MATLAB_DIR=~/redwood_ws/matlab/

echo "starting standard run..."

desktop_vio_standard --data_directory=${DATA_DIR} \
--online_calibration_file=${ONLINE_CALIB_DIR} \
--cad_calibration_file=${CAD_CALIB_DIR} \
--calibration_file=${CALIB_DIR} \
--log_pose_estimates_to_file=true \
--evaluation_log_directory=${DATA_DIR}/${DUMP_FOLDER} \
--rerun_feature_extraction_on_prerecorded_data=true \
--max_number_of_descriptors_to_extract=800 \
--scenegraph_visualize_vio_feature_position=true \
--use_stereo_motion_tracking=true \
--init_ts_sigma=1e-3 \
--use_glx_window_bit=false \
# --disable_opengl=true
# --playback_mode TimeBased \

echo "standard run finished."
echo "Changing file name: " ${HEIGHT_STANDARD}

mv ${HEIGHT_DUMP_DIR}/${HEIGHT_FILE} ${HEIGHT_DUMP_DIR}/${HEIGHT_STANDARD}

echo "starting new module run..."

desktop_vio --data_directory=${DATA_DIR} \
--online_calibration_file=${ONLINE_CALIB_DIR} \
--cad_calibration_file=${CAD_CALIB_DIR} \
--calibration_file=${CALIB_DIR} \
--log_pose_estimates_to_file=true \
--evaluation_log_directory=${DATA_DIR}/${DUMP_FOLDER} \
--rerun_feature_extraction_on_prerecorded_data=true \
--max_number_of_descriptors_to_extract=800 \
--scenegraph_visualize_vio_feature_position=true \
--use_stereo_motion_tracking=true \
--init_ts_sigma=1e-3 \
--use_glx_window_bit=false \
--disable_opengl=true
# --playback_mode TimeBased \

echo "new module run finished."
echo "Changing filename: " HEIGHT_MODULE

mv ${HEIGHT_DUMP_DIR}/${HEIGHT_FILE} ${HEIGHT_DUMP_DIR}/${HEIGHT_MODULE}

echo "comparing data"


echo "Moving data into subdirectory: " ${DATA_NAME}
if [ -d "${HEIGHT_DUMP_DIR}/${DATA_NAME}" ]; then
  rm -r ${HEIGHT_DUMP_DIR}/${DATA_NAME}
fi
mkdir ${HEIGHT_DUMP_DIR}/${DATA_NAME}

mv ${HEIGHT_DUMP_DIR}/${HEIGHT_MODULE} ${MATLAB_DIR}/
mv ${HEIGHT_DUMP_DIR}/${HEIGHT_STANDARD} ${MATLAB_DIR}/

matlab -nodesktop -r "run /usr/local/google/home/mpoulter/redwood_ws/matlab/floor_height_without_vicon.m"


mv ${MATLAB_DIR}/${HEIGHT_MODULE} ${OUTPUT_DIR}/
mv ${MATLAB_DIR}/${HEIGHT_STANDARD} ${OUTPUT_DIR}/
mv ${MATLAB_DIR}/comp.jpg ${OUTPUT_DIR}


echo 'FINISHED!'
