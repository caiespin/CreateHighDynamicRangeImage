function Image = PolyLin(Im,r,g,b, scale)

Image(:,:,1) = r(1) + r(2)*Im(:,:,1) + r(3)*(Im(:,:,1).^2) + r(4)*(Im(:,:,1).^3);
Image(:,:,2) = g(1) + g(2)*Im(:,:,2) + g(3)*(Im(:,:,2).^2) + g(4)*(Im(:,:,2).^3);
Image(:,:,3) = b(1) + b(2)*Im(:,:,3) + b(3)*(Im(:,:,3).^2) + b(4)*(Im(:,:,3).^3);

Image = scale*Image;

end
