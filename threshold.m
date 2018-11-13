function threshold = threshold(image)
    mask = (image < 255);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
threshold = (image.*mask);
end