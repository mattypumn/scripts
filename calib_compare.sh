DATA_DIR=$1
EXIT_CODE_FILE=$2
if [ -z "${EXIT_CODE_FILE}" ]; then
  EXIT_CODE_FILE=1
fi



# Factory calibration: calibration.xml
CALIB_1="${DATA_DIR}/calibration.xml"
# Average calibration is in dataset folder after running download_avg_calib_datasets.m
CALIB_2="${DATA_DIR}/average_calibration.xml"

echo dataset: $DATA_DIR
echo calibration file \#1: ${CALIB_1}
echo calibration file \#2: ${CALIB_2}

# Setup.
PLANE_DIR="${DATA_DIR}/plane_test_output"
mkdir -p ${PLANE_DIR}

ITER=1
STEPS_PER_ITER=4
NUM_ITERS=10
PROGRESS_BAR="${DATA_DIR}  "
PROGRESS_SUM=0
PROGRESS_TOTAL=$((NUM_ITERS * STEPS_PER_ITER))
PROGRESS_TOTAL="${PROGRESS_TOTAL}.0"
RIGHT_COL=${PROGRESS_TOTAL}

RED='\033[0;31m'
NO_COLOR='\033[0m'

SEED_FILE=seed_values.txt
LOG_FILE=log_output.txt

. ~/redwood_ws/devel_linux/setup.sh
for iter in `seq 1 ${NUM_ITERS}`
do
  # echo starting.
  # Build output directories.
  ITER_DIR="${PLANE_DIR}/iter_${iter}"
  VIO_PLANE_1="${ITER_DIR}/vio_plane_1"
  VIO_PLANE_2="${ITER_DIR}/vio_plane_2"
  COM_PLANE_1="${ITER_DIR}/com_plane_1"
  COM_PLANE_2="${ITER_DIR}/com_plane_2"
  mkdir -p ${VIO_PLANE_1} ${VIO_PLANE_2} ${COM_PLANE_1} ${COM_PLANE_2}

  VIO_TANGO_1="${ITER_DIR}/vio_tango_1"
  VIO_TANGO_2="${ITER_DIR}/vio_tango_2"
  COM_TANGO_1="${ITER_DIR}/com_tango_1"
  COM_TANGO_2="${ITER_DIR}/com_tango_2"
  mkdir -p ${VIO_TANGO_1} ${VIO_TANGO_2} ${COM_TANGO_1} ${COM_TANGO_2}



  ## Get random seeds.
  SEED_1=`echo "import random; print random.randint(0,511)" | python`
  SEED_2=`echo "import random; print random.randint(512,1023)" | python`
  echo "${SEED_1} ${SEED_2}" >> ${VIO_TANGO_1}/${SEED_FILE}
  echo "${SEED_1} ${SEED_2}" >> ${VIO_TANGO_2}/${SEED_FILE}
  echo "${SEED_1} ${SEED_2}" >> ${COM_TANGO_1}/${SEED_FILE}
  echo "${SEED_1} ${SEED_2}" >> ${COM_TANGO_2}/${SEED_FILE}

  ##  Build commands.
  # Run VIO with first calibration file
  COMMAND_1="desktop_vio --data_directory=${DATA_DIR} \
  --calibration_file=${CALIB_1} \
  --online_calibration_file=${CALIB_1} \
  --cad_calibration_file=${CALIB_1} \
  --log_pose_estimates_to_file=true \
  --evaluation_log_directory=${VIO_TANGO_1} \
  --rerun_feature_extraction_on_prerecorded_data=true \
  --max_number_of_descriptors_to_extract=800 \
  --scenegraph_visualize_vio_feature_position=true \
  --use_stereo_motion_tracking=false \
  --init_ts_sigma=1e-3 \
  --use_glx_window_bit=false \
  --random_generator_use_random_seed=false \
  --random_generator_seed=${SEED_1} \
  --unique_id_use_random_seed=false \
  --unique_id_seed=${SEED_2} \
  --skip_latent_feature_tracks=false \
  --enable_vio_callback_for_feature_processing=false \
  --disable_opengl=true \
  --enable_plane_detection_from_vio=true \
  --visualize_detected_planes=false \G_floor_ref.last_updated_timestamp == engine_data::INVALID_TIMESTAMP ||

  --playback_mode StepByStep \
  --plane_log_directory=${VIO_PLANE_1}"

  # Run VIO with second calibration file
  COMMAND_2="desktop_vio --data_directory=${DATA_DIR} \
  --calibration_file=${CALIB_2} \
  --online_calibration_file=${CALIB_2} \
  --cad_calibration_file=${CALIB_2} \
  --log_pose_estimates_to_file=true \
  --evaluation_log_directory=${VIO_TANGO_2} \
  --rerun_feature_extraction_on_prerecorded_data=true \
  --max_number_of_descriptors_to_extract=800 \
  --scenegraph_visualize_vio_feature_position=true \
  --use_stereo_motion_tracking=false \
  --init_ts_sigma=1e-3 \
  --use_glx_window_bit=false \
  --random_generator_use_random_seed=false \
  --random_generator_seed=${SEED_1} \
  --unique_id_use_random_seed=false \
  --unique_id_seed=${SEED_2} \
  --skip_latent_feature_tracks=false \
  --enable_vio_callback_for_feature_processing=false \QUIETLY
  --disable_opengl=true \
  --enable_plane_detection_from_vio=true \
  --visualize_detected_planes=false \
  --playback_mode StepByStep \
  --plane_log_directory=${VIO_PLANE_2} "

  # # Run COM with first calibration file
  COMMAND_3="desktop_com --data_directory=${DATA_DIR} \
  --calibration_file=${CALIB_1} \
  --online_calibration_file=${CALIB_1} \
  --cad_calibration_file=${CALIB_1} \
  --log_pose_estimates_to_file=true \
  --evaluation_log_directory=${COM_TANGO_1} \
  --rerun_feature_extraction_on_prerecorded_data=true \
  --max_number_of_descriptors_to_extract=800 \
  --scenegraph_visualize_vio_feature_position=true \
  --use_stereo_motion_tracking=false \
  --init_ts_sigma=1e-3 \
  --use_glx_window_bit=false \
  --random_generator_use_random_seed=false \
  --random_generator_seed=${SEED_1} \
  --unique_id_use_random_seed=false \
  --VIWLS_execute_in_thread=false \
  --unique_id_seed=${SEED_2} \
  --skip_latent_feature_tracks=false \
  --enable_vio_callback_for_feature_processing=false \
  --disable_opengl=true \
  --enable_plane_detection_from_vio=true \
  --visualize_detected_planes=false \
  --playback_mode StepByStep \
  --plane_log_directory=${COM_PLANE_1} "

  # # Run COM with second calibration file
  COMMAND_4="desktop_com --data_directory=${DATA_DIR} \
  --calibration_file=${CALIB_2} \
  --online_calibration_file=${CALIB_2} \
  --cad_calibration_file=${CALIB_2} \
  --log_pose_estimates_to_file=true \
  --evaluation_log_directory=${COM_TANGO_2} \
  --rerun_feature_extraction_on_prerecorded_data=true \
  --max_number_of_descriptors_to_extract=800 \
  --scenegraph_visualize_vio_feature_position=true \
  --VIWLS_execute_in_thread=false \
  --use_stereo_motion_tracking=false \G_floor_ref.last_updated_timestamp == engine_data::INVALID_TIMESTAMP ||

  --init_ts_sigma=1e-3 \
  --use_glx_window_bit=false \
  --random_generator_use_random_seed=false \
  --random_generator_seed=${SEED_1} \
  --unique_id_use_random_seed=false \
  --unique_id_seed=${SEED_2} \
  --skip_latent_feature_tracks=false \
  --enable_vio_callback_for_feature_processing=true \G_floor_ref.last_updated_timestamp == engine_data::INVALID_TIMESTAMP ||

  --disable_opengl=true \
  --enable_plane_detection_from_vio=true \
  --visualize_detected_planes=false \
  --playback_mode StepByStep \
  --plane_log_directory=${COM_PLANE_2}"

  ###################################### Run command strings with fail checking.
  RETVAL=7
  COUNTER=0
  SAFETY=5
  until ((RETVAL == 0 || COUNTER >=SAFETY)); do
    echo ======================================= >> ${VIO_TANGO_1}/output.txt
    $COMMAND_1  >> ${VIO_TANGO_1}/${LOG_FILE} 2>&1
    RETVAL=$?
    ((COUNTER++))
  done
  if ((RETVAL != 0)); then
    echo -e ${RED} ERROR 1: iteration ${iter} ${NO_COLOR}
    echo "${DATA_DIR} 1" >> ${EXIT_CODE_FILE}
    exit 1
  fi
  (( PROGRESS_SUM++ ))
  PROGRESS_BAR="${PROGRESS_BAR}#"
  PROGRESS_PERCENT="`echo print 100*${PROGRESS_SUM}/${PROGRESS_TOTAL} | python`"
  echo -ne ${PROGRESS_BAR}  "${PROGRESS_PERCENT}%\r"


  RETVAL=7
  COUNTER=0
  until ((RETVAL == 0 || COUNTER >=SAFETY)); do
    echo ======================================= >> ${VIO_TANGO_2}/output.txt
    $COMMAND_2 >> ${VIO_TANGO_2}/${LOG_FILE} 2>&1
    RETVAL=$?
    ((COUNTER++))
  done
  if ((RETVAL != 0)); then
    echo -e ${RED} ERROR 2:  iteration ${iter} ${NO_COLOR}
    echo "${DATA_DIR} 1" >> ${EXIT_CODE_FILE}
    exit 1
  fi
  (( PROGRESS_SUM++ ))
  PROGRESS_BAR="${PROGRESS_BAR}#"
  PROGRESS_PERCENT="`echo print 100*${PROGRESS_SUM}/${PROGRESS_TOTAL} | python`"
  echo -ne ${PROGRESS_BAR}  "${PROGRESS_PERCENT}%\r"




  RETVAL=7
  COUNTER=0
  until ((RETVAL == 0 || COUNTER >=SAFETY)); do
    echo ======================================= >> ${COM_TANGO_1}/output.txt
    $COMMAND_3 >> ${COM_TANGO_1}/${LOG_FILE} 2>&1
    RETVAL=$?
    ((COUNTER++))
  done
  if ((RETVAL != 0)); then
    echo -e ${RED} ERROR 3:  iteration ${iter} ${NO_COLOR}
    echo "${DATA_DIR} 1" >> ${EXIT_CODE_FILE}
    exit 1
  fi
  (( PROGRESS_SUM++ ))
  PROGRESS_BAR="${PROGRESS_BAR}#"
  PROGRESS_PERCENT="`echo print 100*${PROGRESS_SUM}/${PROGRESS_TOTAL} | python`"
  echo -ne ${PROGRESS_BAR}  "${PROGRESS_PERCENT}%\r"

  RETVAL=7
  COUNTER=0
  until ((RETVAL == 0 || COUNTER >=SAFETY)); do
    echo ======================================= >> ${COM_TANGO_2}/output.txt
    $COMMAND_4 >> ${COM_TANGO_2}/${LOG_FILE} 2>&1
    RETVAL=$?
    ((COUNTER++))
  done
  if ((RETVAL != 0)); then
    echo -e ${RED} ERROR 4:  iteration ${iter} ${NO_COLOR}
    exit 1
  fi
  (( PROGRESS_SUM++ ))
  PROGRESS_BAR="${PROGRESS_BAR}#"
  PROGRESS_PERCENT="`echo print 100*${PROGRESS_SUM}/${PROGRESS_TOTAL} | python`"
  echo -ne ${PROGRESS_BAR}  "${PROGRESS_PERCENT}%\r"
done

# Run MATLAB to compare results of different runs.
# matlab /r " VICON_DATA=${VICON_FILE}; TANGO_BASE_DIR=${TANGO_DIR}; PLANE_BASE_DIR=${OUTPUT_DIR}; ${MATLAB_SCRIPT}" > plane_compare.txt
# cat plane_compare.txt
echo
# echo Done!!
echo "${DATA_DIR} 0" >> ${EXIT_CODE_FILE}
