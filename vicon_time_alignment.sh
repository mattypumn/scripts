#make sure that vicon file is saved in dataset folder as target_poses.txt
DATASET=$1
#source ~/redwood_ws/RedwoodInternal/build_system/setup.sh
#redwood_make --platform linux vicon tango_hal
#source ~/redwood_ws/devel_linux/setup.bash
cd $DATASET
# && tango_hal_exporter bag dump
#cat dump/gyro.txt | sed 's/ /,/g' > gyro.txt
#rm -rf dump
auto_vicon_tango_time_offset.py \
  --gyro_filename gyro.txt --vicon_filename target_poses.txt \
  --vicon_run_frequency 500 #--figures_location $DATASET
echo 500 > time_alignment.txt
#cat ./time_align.txt >> time_alignment.txt
#rm plot_digests.svg CrossCorrelation.png
echo DONE!
