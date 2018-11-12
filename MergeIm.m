function pic_combine_a = MergeIm(im1,im2,im3,a,scale)
im1_a = im1/a(1);
im2_a = im2/a(2);
im3_a = im3/a(3);
threshold_mask = (im1_a > im2_a);
threshold = threshold_mask(:,:,1).*threshold_mask(:,:,2).*threshold_mask(:,:,3);
threshold_mask(:,:,1) = double(threshold);
threshold_mask(:,:,2) = double(threshold);
threshold_mask(:,:,3) = double(threshold);
mask1 = threshold_mask;
figure()
subplot(2,3,1)
imshow(uint8(mask1)*255);
im1 = (im1.*mask1);
subplot(2,3,4)
imshow(uint8(im1/scale));
%im1 = (im1.*mask1)/a(1);
mask2 = not(mask1);
im2 = (im2.*mask2);
%im2 = (im2.*mask2)/a(2);
subplot(2,3,2)
imshow(uint8(mask2)*255);
subplot(2,3,5)
imshow(uint8(im2/scale));
pic_combine = im1+im2;
pic_combine_a = im1_a+im2_a;
%------------------------%
%threshold_mask = not(rgb2gray(pic_combine_a) == 255);
threshold_mask = (pic_combine_a > im3_a);
threshold = threshold_mask(:,:,1).*threshold_mask(:,:,2).*threshold_mask(:,:,3);
threshold_mask(:,:,1) = double(threshold);
threshold_mask(:,:,2) = double(threshold);
threshold_mask(:,:,3) = double(threshold);
mask1 = threshold_mask;
pic_combine = pic_combine.*mask1;
mask2 = not(mask1);
subplot(2,3,3)
imshow(uint8(mask2)*255);
im3 = im3.*mask2;
subplot(2,3,6)
imshow(uint8(im3/scale));
%im3 = (im3.*mask2)/a(3);
pic_combine = pic_combine+im3;
pic_combine_a = pic_combine_a+im3_a;
% figure
% imshow(uint8(pic_combine/scale));
