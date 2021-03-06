DATA_DIR=$1
# DATA_DIR=/usr/local/google/home/mpoulter/for_matt/polaris_floor_vicon/mrinal/1
CALIB_DIR=${DATA_DIR}/calibration.xml
CAD_CALIB_DIR=${DATA_DIR}/cad-calibration.xml
ONLINE_CALIB_DIR=${DATA_DIR}/online-calibration.xml

desktop_vio --data_directory=${DATA_DIR} \
--calibration_file=${CALIB_DIR} \
--online_calibration_file=${ONLINE_CALIB_DIR} \
--cad_calibration_file=${CAD_CALIB_DIR} \
--log_pose_estimates_to_file=true \
--evaluation_log_directory=${DATA_DIR}/out \
--rerun_feature_extraction_on_prerecorded_data=true \
--max_number_of_descriptors_to_extract=800 \
--scenegraph_visualize_vio_feature_position=true \
--use_stereo_motion_tracking=false \
--init_ts_sigma=1e-3 \
--use_glx_window_bit=false \
--random_generator_use_random_seed=false \
--random_generator_seed=111 \
--unique_id_use_random_seed=false \
--unique_id_seed=222 \
--skip_latent_feature_tracks=false \
--enable_vio_callback_for_feature_processing=false \
--disable_opengl=false \
--enable_plane_detection_from_vio=true \
--visualize_detected_planes=true \
--playback_mode StepByStep \
# --use_landmark_triangulator_for_estimated_landmarks=true \ # Used for mono-triangulation
# --offline_feature_detection_frequency=30 \
# --min_time_between_processed_features=0 \
