#!/usr/bin/env python
from __future__ import print_function
from subprocess import call
import sys
import os
import numpy as np
import cv2
from matplotlib import pyplot as plt
import time


def wait():
    raw_input("Press Enter to continue...");



def row(matrix, i):
    return [col[i] for col in matrix];

def column(matrix, i):
    return [row[i] for row in matrix];



def main(argv):
    kNumGrabCutIters = 5;
    base_dir=sys.argv[1];

    # Setup.
    image_dir = os.path.join(base_dir, 'dump', 'feature_tracking_primary');
    bounding_box_file = os.path.join(base_dir, 'dump', 'finger_bounding_box.txt');
    bounding_info = np.genfromtxt(bounding_box_file, delimiter=",");
    image_format = 'image_%05d.ppm';
    output_dir = os.path.join(base_dir, 'dump', 'grabcut');
    grabcut_format = 'grabcut_%05d.jpg';


    # Create output dir if needed.
    call(['mkdir', '-p', output_dir]);

    timer_list = list();
    plt.hold(False);
    total_iters = len(bounding_info);
    counter = 0;
    print(('%.2f' % (float(counter) / total_iters * 100)) + ' %', end='\r');
    sys.stdout.flush();
    # traverse by row.
    for row_i in bounding_info:
        #  Extract data.
        image_num = row_i[0].astype('uint32');
        top_left_x = row_i[1].astype('uint32');
        top_left_y = row_i[2].astype('uint32');
        height = row_i[3].astype('uint32');
        width = row_i[4].astype('uint32');
        rect = (top_left_x-1, top_left_y-1, width, height);

        # Skip if not in bounds.
        if rect[0] < 0 or rect[1] < 0 or width < 1 or height < 1:
            continue;

        # Load image.
        image_name = image_format % image_num;
        image_fullname = os.path.join(image_dir, image_name);
        cv_img = cv2.imread(image_fullname);

        # Create mask mats for opencv.
        mask = np.zeros(cv_img.shape[:2], np.uint8);
        bgdModel = np.zeros((1,65),np.float64);
        fgdModel = np.zeros((1,65),np.float64);

        # Run OpenCV.
        start = time.time();
        cv2.grabCut(cv_img, mask, rect, bgdModel, fgdModel, kNumGrabCutIters, \
                    cv2.GC_INIT_WITH_RECT);
        timer_list.append(time.time() - start);

        # Reshape returned mask for concatenation.
        final_mask = np.where((mask==cv2.GC_BGD) | (mask==cv2.GC_PR_BGD),  \
                               0, 1).astype('uint8') * 255;
        final_mask = final_mask[:, :, np.newaxis];
        final_mask = np.concatenate((final_mask, final_mask, final_mask), \
                                    axis=2);

        # Concat the two images
        b,g,r = cv2.split(cv_img);
        rgb_img = cv2.merge([r,g,b]);
        stitched_img_show = np.hstack((rgb_img, final_mask));
        stitched_img_save = np.hstack((cv_img, final_mask));

        ## Show the image.
        # plt.imshow(stitched_img_show);
        # plt.show(block=False);

        # Save the image.
        outfile = grabcut_format % image_num;
        outfullfile = os.path.join(output_dir, outfile);
        cv2.imwrite(outfullfile, stitched_img_save);

        counter = counter + 1;
        print(('%.2f' % (float(counter) / total_iters * 100)) + ' %', end='\r');
        sys.stdout.flush();

    print('Timing Statistics: ');
    print('mean: ', np.average(timer_list));
    print('std-dev: ', np.std(timer_list));
    print('min: ', np.min(timer_list));
    print('max: ', np.max(timer_list));

if __name__ == '__main__':
    if len(sys.argv) == 2:
        main(sys.argv);
        print('Done!');
    else:
        print("Usage: " + sys.argv[0] + " <dataset-directory>");
