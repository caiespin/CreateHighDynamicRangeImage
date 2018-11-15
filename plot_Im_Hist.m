clc
clear all

% gain = 800;
% ExposureTimes = [1/2000 1/1000 1/500 1/125 1/60 1/30];
% I_1 = imread('Mission Chapel/_DSF1679.JPG');
% I_2 = imread('Mission Chapel/_DSF1678.JPG');
% I_3 = imread('Mission Chapel/_DSF1677.JPG');
% I_4 = imread('Mission Chapel/_DSF1674.JPG');
% I_5 = imread('Mission Chapel/_DSF1675.JPG');
% I_6 = imread('Mission Chapel/_DSF1676.JPG');

gain = 2000;
ExposureTimes = [1/4 1/8 1/15 1/30 1/60 1/125];
I_1 = imread('Bike/_DSF1700.JPG');%1/4
I_2 = imread('Bike/_DSF1701.JPG');%1/8
I_3 = imread('Bike/_DSF1702.JPG');%1/15
I_4 = imread('Bike/_DSF1703.JPG');%1/30
I_5 = imread('Bike/_DSF1704.JPG');%1/60
I_6 = imread('Bike/_DSF1705.JPG');%1/125

figure
subplot(3,4,1)
threshold_mask = not(rgb2gray(I_1) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_1.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(1));
title(str)
subplot(3,4,2)
imhist(I_1)
axis([0 255 0 2.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

subplot(3,4,3)
threshold_mask = not(rgb2gray(I_2) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_2.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(2));
title(str)
subplot(3,4,4)
imhist(I_2)
axis([0 255 0 2.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

subplot(3,4,5)
threshold_mask = not(rgb2gray(I_3) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_3.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(3));
title(str)
subplot(3,4,6)
imhist(I_3)
axis([0 255 0 1.5*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

subplot(3,4,7)
threshold_mask = not(rgb2gray(I_4) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_4.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(4));
title(str)
subplot(3,4,8)
imhist(I_4)
axis([0 255 0 1.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

subplot(3,4,9)
threshold_mask = not(rgb2gray(I_5) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_5.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(5));
title(str)
subplot(3,4,10)
imhist(I_5)
axis([0 255 0 1.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

subplot(3,4,11)
threshold_mask = not(rgb2gray(I_6) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_6.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(6));
title(str)
subplot(3,4,12)
imhist(I_6)
axis([0 255 0 1.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)