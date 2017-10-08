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

def ExtractMarkerMasksFromCoords(bounding_box, coords_vec):
    assert ( len(coords_vec) % 2 == 0 );
    ret_masks = list();

    top_left_x = bounding_box[0];
    top_left_y = bounding_box[1];
    width = bounding_box[2];
    height = bounding_box[3];

    for coord_i in range(0, len(coords_vec), 2):
        pix_x = coords_vec[coord_i];
        pix_y = coords_vec[coord_i + 1];
        mask_x  = pix_x - top_left_x;
        mask_y = pix_y - top_left_y;
        if mask_x < 0 or mask_y < 0 or mask_x >= width or mask_y >= height:
            continue;

        mask = np.zeros((height, width), np.uint8);
        for row_i in range(len(mask)):
            for col_i in range(len(mask[row_i])):
                diff_x = abs(col_i - mask_x);
                diff_y = abs(row_i - mask_y);
                if diff_x < 0 and diff_y < 9:
                    mask[row_i, col_i] = cv2.GC_FGD;
        ret_masks.append(mask);

    return ret_masks;


def main(argv):
    kNumGrabCutIters = 5;
    kStartImage = 100;
    base_dir=sys.argv[1];

    # Setup.
    image_dir = os.path.join(base_dir, 'dump', 'feature_tracking_primary');
    bounding_box_file = os.path.join(base_dir, 'dump',
                                     'finger_bounding_box.txt');
    marker_pixels_file = os.path.join(base_dir,'dump', 'marker_pixels.txt');
    bounding_info = np.genfromtxt(bounding_box_file, delimiter=",");
    marker_info = np.genfromtxt(marker_pixels_file, delimiter=",");
    assert(len(marker_info) == len(bounding_info));

    image_format = 'image_%05d.ppm';
    output_dir = os.path.join(base_dir, 'dump', 'grabcut_refined1');
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
    for row_i in range(len(bounding_info)):
        if row_i < kStartImage :
            counter = counter + 1;
            continue;

        crop_info_i = bounding_info[row_i];
        marker_info_i = marker_info[row_i];
        assert (marker_info_i[0] == crop_info_i[0]);

        #  Extract Box data.
        image_num = crop_info_i[0].astype('uint32');
        #  Fix 1-indexing used by matlab.
        top_left_x = crop_info_i[1].astype('uint32') - 1;
        top_left_y = crop_info_i[2].astype('uint32') - 1;
        height = crop_info_i[3].astype('uint32');
        width = crop_info_i[4].astype('uint32');
        rect = (top_left_x, top_left_y, width, height);

        # Fix the 1-indexing used by matlab!
        marker_info_i = marker_info_i[1:] - 1;

        # Extract marker_masks  (cropped)
        marker_masks = ExtractMarkerMasksFromCoords(rect, marker_info_i);

        # Skip if not in bounds.
        if top_left_x < 0 or top_left_y < 0 or height < 1 or width < 1:
            # print('Could not extract bounding box ' + str(image_num));
            counter = counter + 1;
            continue;

        if len(marker_masks) == 0:
            # print('Could not extract marker box ' + str(image_num));
            counter = counter + 1;
            continue;

        # Load image.
        image_name = image_format % image_num;
        image_fullname = os.path.join(image_dir, image_name);
        cv_img = cv2.imread(image_fullname);
        full_mask = np.zeros(cv_img.shape[:2], np.uint8);

        # Histograms for GrabCut.
        bgdModel = np.zeros((1,65),np.float64);
        fgdModel = np.zeros((1,65),np.float64);

        # Run GrabCut using the rect on original image.
        start = time.time();
        cv2.grabCut(cv_img, full_mask, rect, bgdModel, fgdModel,  \
                    kNumGrabCutIters, cv2.GC_INIT_WITH_RECT);
        timer_list.append(time.time() - start);

        ## DEBUG
        # Reshape for concatenation.
        full_mask = np.where((full_mask==2) | (full_mask==0), \
                             0, 1).astype('uint8') * 255;
        full_mask = full_mask[:, :, np.newaxis];
        full_mask = np.concatenate((full_mask, full_mask, full_mask), \
                                            axis=2);
        # Concat the two images
        b,g,r = cv2.split(cv_img);
        rgb_img = cv2.merge([r,g,b]);
        stitched_img_show = np.hstack((rgb_img, full_mask));

        plt.imshow(stitched_img_show);
        plt.show(block=False);
        wait();
        ## End DEBUG

        # Crop image.
        crop_img = cv_img[top_left_y : top_left_y + height, \
                          top_left_x : top_left_x + width ];
        # Mask for combining returned masks from OpenCV.
        final_mask = np.zeros(crop_img.shape[:2], np.uint8);


        # Run OpenCV.
        for marker_mask in marker_masks:
            print( "size crop_img: " + str(crop_img.shape));
            print("mask shape: " + str(marker_mask.shape));

            # Create Mats for opencv.
            start = time.time();
            tmp_mask, tmp_bgd, tmp_fgd = cv2.grabCut(crop_img, marker_mask,  \
                                 None, bgdModel, fgdModel, kNumGrabCutIters, \
                                 cv2.GC_INIT_WITH_MASK);
            timer_list.append(time.time() - start);

            # Set foreground_pixel = 0
            tmp_mask = np.where((mask==2) | (mask==0), 0, 1).astype('uint8');

            # Add to final mask.
            final_mask = final_mask + tmp_mask;

        final_mask = np.where((final_mask > 0), 1, 0).astype('uint8');
        final_mask = final_mask * 255;

        # Reshape returned mask for concatenation.
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

        wait();

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
