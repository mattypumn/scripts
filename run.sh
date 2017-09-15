#!/bin/bash
cd ~/for_matt/height_out

FILE=stable_height.txt


~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_hall/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_hall_0_fklt.txt
fi
~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_hall/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_hall_45_fklt.txt
fi
~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_hall/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_hall_90_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_kitchen/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_kitchen_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_kitchen/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_kitchen_45_fklt.txt
fi


~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_kitchen/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_kitchen_90_fklt.txt
fi


~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_patio/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_patio_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_patio/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_patio_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_patio/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_patio_90_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_ws/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_ws_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/pr55_ws/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_pr55_ws_90_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb10_juice/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb10_juice_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb10_juice/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb10_juice_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb10_juice/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb10_juice_90_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb10_meditation/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb10_meditation_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb10_meditation/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb10_meditation_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb10_meditation/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb10_meditation_90_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_hall/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_hall_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_hall/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_hall_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_kitchen/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_kitchen_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_kitchen/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_kitchen_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_kitchen/50deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_kitchen_50_fklt.txt
fi


~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_office/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_office_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_office/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_office_45_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_office/90deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_office_90_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_road/0deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_road_0_fklt.txt
fi

~/redwood_ws/scripts/desktop_vio.sh ~/for_matt/polaris/sb65_road/45deg
if [ -f ${FILE} ]; then
  mv ${FILE} stable_height_sb65_road_45_fklt.txt
fi
