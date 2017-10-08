#!/usr/bin/env python

import xml.etree.ElementTree as ET
import sys
import os

XML_FILE="cad-calibration.xml";
OUT_FILE="camera.txt";

def parse_xml_for_intrinsics(fullfile):
    height = 0;
    width = 0;
    intrinsics = list();
    cam_type = '';

    tree = ET.parse(fullfile);
    root = tree.getroot();
    for camera in root.findall('camera'):
        camera_model = camera.find('camera_model')
        if camera_model.attrib['index'] == '0':
            cam_type = camera_model.attrib['type']
            height = int( camera_model.find('height').text );
            width = int( camera_model.find('width').text );
            array_str = camera_model.find('params').text ;
            array_str = array_str.replace('[','');
            array_str = array_str.replace(']','');
            array_str = array_str.replace(';','');
            array = array_str.split();
            for i in range( len (array)):
                intrinsics.append( float(array[i]) );

    return {'height':height, 'width':width, 'intrinsics':intrinsics, 'type':cam_type};

def output_simple_calibration_file(fullfile, camera_data):
    height = camera_data['height'];
    width = camera_data['width'];
    intrinsics = camera_data['intrinsics'];
    type_split = camera_data['type'].split('_');
    # intrinsics (list): fc_u fc_v cc_u cc_v kc_vec
    assert(type_split[1] == 'fu');
    assert(type_split[2] == 'fv');
    assert(type_split[3] == 'u0');
    assert(type_split[4] == 'v0');

    size = len(intrinsics);

    if size == 5 or size == 7:
        fid = open(fullfile, 'w');
        # print('Not yet implemented.5 || 7');
        first_third_line = '%f %f %f %f' % \
                    (intrinsics[0] / width, intrinsics[1] / height, \
                     intrinsics[2] / width, intrinsics[3] / height);
        for kc_val in intrinsics[4:]:
            first_third_line += ' %f' % kc_val;
        # print('built line: ' + first_third_line);
        print('Writing to file: ' + fullfile);
        fid.write(first_third_line + '\n');
        fid.write('%d %d' % (width, height) + '\n');
        fid.write(first_third_line + '\n');
        fid.write('%d %d' % (width, height) + '\n');
    else:
        print ('Unexpected length of intrinsics.');
        assert(False);

    fid.close();


def main():
    base_dir=sys.argv[1];

    print('base_dir: %s' % base_dir)

    for dirName, subdirList, fileList in os.walk(base_dir):
        found = False;
        for f in fileList:
            if os.path.basename(f) == XML_FILE:
                curr_xml_file = os.path.join(dirName, f);
                curr_txt_file = os.path.join(dirName, OUT_FILE);
                print('Calibration XML found: ' + curr_xml_file);
                camera_data = parse_xml_for_intrinsics(curr_xml_file);
                output_simple_calibration_file(curr_txt_file, camera_data);

        if not found:
            print('Could not find Calibration xml: ' + os.path.join(dirName, XML_FILE));
if __name__ == "__main__":
    main()
