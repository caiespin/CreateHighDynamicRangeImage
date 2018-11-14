%HDRAC--HDR algorithm by Aaron and Carlos
clear all;
%close all;

%% Calculate the Fuji X-E1 compression algorithm
[mean_RF, mean_BF, mean_GF, T, gain, Imfiles] = RadioCalData('G800',[1600 830 300 300],true);

%% Calculate the compression algorithm
%Polinomial fitting
[r_inv, g_inv, b_inv] = CalcPolCoef(mean_RF,mean_GF,mean_BF, T);
scale = 255; 
%Exponential fitting B^g
[gR, gG, gB] = CalcG2(mean_RF,mean_GF,mean_BF, T,true);

%% Normalize image data
fName = ('Mission Chapel/_DSF1678.JPG');
im_scale = 255/pixel_fit(255,1,r_inv,b_inv,b_inv,scale);
%fName = ('Bike/_DSF1704.JPG')
Pic1 = imread(fName);
x_max = size(Pic1, 1);
y_max = size(Pic1, 2);
color_max = 3;
scale = 255.0;
Pic1_norm = double(Pic1);
Pic1_lin = zeros(x_max,y_max,color_max);

for x = 1:x_max
    for y = 1:y_max
        for color = 1:color_max %R = 1, G = 2 B = 3
            alpha = Pic1_norm(x,y,color);
            alpha_lin = pixel_fit(alpha,color,r_inv,b_inv,b_inv,scale);
            Pic1_lin(x,y,color) = alpha_lin;
        end
    end
end
Pic1_lin = Pic1_lin*im_scale;

figure()
subplot(3,2,[1 3 5])
imshow(uint8(Pic1_lin));  
subplot(3,2,2)
histogram(Pic1_lin(:,:,1))
subplot(3,2,4)
histogram(Pic1_lin(:,:,2))
subplot(3,2,6)
histogram(Pic1_lin(:,:,3))
%% Scale image 2 Middle picture

fName = ('Mission Chapel/_DSF1674.JPG');
%fName = ('Bike/_DSF1702.JPG')
Pic2 = imread(fName);
x_max = size(Pic2, 1);
y_max = size(Pic2, 2);
color_max = 3;
Pic2_norm = double(Pic2);
Pic2_lin = zeros(x_max,y_max,color_max);
for x = 1:x_max
    for y = 1:y_max
        for color = 1:color_max %R = 1, G = 2 B = 3
            alpha = Pic2_norm(x,y,color);
            alpha_lin = pixel_fit(alpha,color,r_inv,b_inv,b_inv,scale);
            Pic2_lin(x,y,color) = alpha_lin;
        end
    end
end


Pic2_lin = Pic2_lin*im_scale;
Pic2_lin = threshold(Pic2_lin);

figure()
subplot(3,2,[1 3 5])
imshow(uint8(Pic2_lin));  
subplot(3,2,2)
histogram(Pic2_lin(:,:,1))
subplot(3,2,4)
histogram(Pic2_lin(:,:,2))
subplot(3,2,6)
histogram(Pic2_lin(:,:,3))
%% Pic 3 lightest picture
fName = ('Mission Chapel/_DSF1676.JPG')
%fName = ('Bike/_DSF1701.JPG')
Pic3 = imread(fName);
x_max = size(Pic3, 1);
y_max = size(Pic3, 2);
color_max = 3;
Pic3_norm = double(Pic3);
Pic3_lin = zeros(x_max,y_max,color_max);
for x = 1:x_max
    for y = 1:y_max
        for color = 1:color_max %R = 1, G = 2 B = 3
            alpha = Pic3_norm(x,y,color);
            alpha_lin = pixel_fit(alpha,color,r_inv,b_inv,b_inv,scale);
            Pic3_lin(x,y,color) = alpha_lin;
        end
    end
end

Pic3_lin = Pic3_lin*im_scale;
Pic3_lin = threshold(Pic3_lin);

figure()
subplot(3,2,[1 3 5])
imshow(uint8(Pic3_lin));  
subplot(3,2,2)
histogram(Pic3_lin(:,:,1))
subplot(3,2,4)
histogram(Pic3_lin(:,:,2))
subplot(3,2,6)
histogram(Pic3_lin(:,:,3))

%% Scale by ratio of time
t = [1/1000;1/125;1/30];
%t = [1/60;1/15;1/8];

a(1) = 1;
a(2) = t(2)/t(1); %scale factor between image two and one
a(3) = t(3)/t(1); %scale factor betweem image three and image one
%composition 1
comp1HDR = pic_combine(Pic1_lin,Pic2_lin,Pic3_lin,a);
comp1 = tonemap(comp1HDR,'AdjustSaturation',2.5, 'AdjustLightness', [0.15 1]);
figure()
comp1_rsize = imresize(comp1, 0.35);
imshow(comp1_rsize)
%% composition 2
Image = ImMerge2(Pic1_lin,Pic2_lin,Pic3_lin,a);
comp2 = tonemap(Image,'AdjustSaturation',2.5, 'AdjustLightness', [0.15 1]);
figure()
comp2_rsize = imresize(comp2, 0.35);
imshow(comp2_rsize)

