DATASET=$1

#redwood_make --platform linux desktop_viwls
#redwood_make --platform linux benchmarking

mkdir -p $DATASET/viwls_output/

desktop_viwls --data_directory=$DATASET \
--calibration_file=$DATASET/cad-calibration.xml \
--cad_calibration_file=$DATASET/cad-calibration.xml \
--online_calibration_file=$DATASET/cad-calibration.xml \
--alsologtostderr --colorlogtostderr \
--evaluation_log_directory $DATASET/viwls_output/ \
--VIWLS_online_calibration=true \
--VIWLS_nonlinear_optimization_type='NLWLS_outlier_rejection' \
--VIWLS_calibrate_imu_camera_extrinsics=true \
--VIWLS_log_state_to_file=true \
--VIWLS_calibrate_imu_intrinsics=true \
--visualize_vio_feature_lifecycle=true \
--scenegraph_visualize_vio_feature_position=true \
--rerun_feature_extraction_on_prerecorded_data=true

echo "Finished Bundle Adjustment."

# Step 2, run handeye
file=$DATASET/time_alignment.txt
FREQUENCY=$(head -1 "$file")
TIME_OFFSET=$(tail -1 "$file")

vicon_hand_eye_calibration --vicon_data_file $DATASET/axe_pose.txt \
--tango_data_file  $DATASET/viwls_output/viwls_time_poses.txt \
--vicon_frequency=500 \
--compute_new_tango_vicon_calibration=true \
--select_every_nth_tango_frame=1 --alsologtostderr \
--time_offset_between_tango_vicon_clocks=${TIME_OFFSET} \
--tango_vicon_spatial_calibration_file  $DATASET/Tango_to_Vicon_Calibration.txt

echo "DONE!"
