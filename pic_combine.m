function pic_combine = pic_combine(im1,im2,im3,a)

mask = (im2 < im1);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
%mask for the first image where it has the highest exposure pixels 
mask1 = mask;
im1 = (im1.*mask1);
%invert the mask for the second image
mask2 = not(mask1);
%downscale by time for merging
im2 = (im2.*mask2)/a(2);

pic_combine = im1+im2;
%------------------------%
% Second Masking step
%------------------------%
mask = (im3 < pic_combine);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
%mask the combined image with the third image
mask3 = mask;
pic_combine = (pic_combine.*mask3);
%invert the mask for the third image mask
mask4 = not(mask3);
%reduce exposure by time factor and merge
im3 = (im3.*mask4)/a(3);
pic_combine = pic_combine+im3;
% % UNCOMMENT FOR MASK IMAGES
% figure()
% subplot(2,2,1)
% imshow(uint8(mask1)*255);
% subplot(2,2,2)
% imshow(uint8(mask2)*255);
% subplot(2,2,3)
% imshow(uint8(mask3)*255);
% subplot(2,2,4)
% imshow(uint8(mask4)*255);
 end

