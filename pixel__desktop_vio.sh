DATA_DIR=$1
# DATA_DIR=/usr/local/google/home/mpoulter/for_matt/polaris_floor_vicon/mrinal/1
echo 'DATA_DIR ' ${DATA_DIR}
CALIB_DIR=${DATA_DIR}/calibration.xml
CAD_CALIB_DIR=${DATA_DIR}/cad-calibration.xml
ONLINE_CALIB_DIR=${DATA_DIR}/online-calibration.xml

desktop_vio --data_directory=${DATA_DIR} \
--online_calibration_file=${ONLINE_CALIB_DIR} \
--cad_calibration_file=${CAD_CALIB_DIR} \
--calibration_file=${CALIB_DIR} \
--log_pose_estimates_to_file=true \
--evaluation_log_directory=${DATA_DIR}/out \
--rerun_feature_extraction_on_prerecorded_data=true \
--max_number_of_descriptors_to_extract=800 \
--scenegraph_visualize_vio_feature_position=true \
--init_ts_sigma=1e-3 \
--use_glx_window_bit=false \
--use_stereo_motion_tracking=false \
# --disable_opengl=true
# --playback_mode TimeBased \
