function Image  = ImMerge2(im1,im2,im3,a)
figure()
mask = im1> 255/a(2);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
%mask for the first image where it has the highest exposure pixels 
mask1 = mask;

mask = im1 < 255/a(3);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
mask3 = mask;

mask2 = not(mask1) .* not(mask3);

Image1 = (im1.*mask1);
Image2 = (im1.*mask2 + im2.*mask2/a(2))/2;
Image3 = (im1.*mask3 + (im2.*mask3)/a(2) +(im3.*mask3)/a(3))/3;

subplot(1,4,1)
imshow(uint8(mask1*255));
subplot(1,4,2)
imshow(uint8(mask2*255));
subplot(1,4,3)
imshow(uint8(mask3*255));
subplot(1,4,4)
imshow(uint8(mask1 + mask2 + mask3)*255)

Image = Image1 + Image2 + Image3;
end


