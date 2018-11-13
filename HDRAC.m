%HDRAC--HDR algorithm by Aaron and Carlos
clear all;
close all;

%% Generate the Fuji X-E2 Radiometric calibration
%filename base string
baseFujiFName = 'Gamma_img/FUJI/_DSF16';
%extension string
fext = '.JPG';
%which files to use
baseFujiFN = 87-1; %first file is 87
x_min = 1600;
y_min = 1000;
%exposure data
times_fuji = [1/4000;1/2000;1/1000;1/500;1/250;1/125;1/60];
files = size(times_fuji,1);
time = num2str(times_fuji);

figure()
for file = 1:files
    %choose the file based on the index
    FN = baseFujiFN+file;
    FNstr = num2str(FN);
    %calculate the filename
    fName = strcat(baseFujiFName,FNstr,fext);
    %read image data
    pic = imread(fName);
    %mask off central white portion
    mask = imcrop(pic,[x_min y_min,100,100]);
    subplot(1,files,file)
    imshow(mask)
    timeStr = num2str(times_fuji(file,1));
    title(strcat('t = ' , timeStr),'fontsize',10)
    %split into channels
    RF = mask(:,:,1);
    GF = mask(:,:,2);
    BF = mask(:,:,3);
    %calculate mean brightness
    mean_RF(file) = mean2(RF);
    mean_GF(file) = mean2(GF);
    mean_BF(file) = mean2(BF);
end
%Show all the data from the exposure tests

figure()
plot(times_fuji,mean_RF,'r--x')
hold on
plot(times_fuji,mean_BF, 'b--x')
plot(times_fuji,mean_GF, 'g--x')
hold off
ax = gca;
ax.FontSize = 12;
title('Fuji X-E2 Camera Compression Data')
xlabel('Exposure time [sec]')
ylabel('Brightness [au]')
legend('Red','Blue','Green')
%% Calc Linearization Parameters
%for the Fuji camera:
t = times_fuji;

fit_lin = r(1) + r(2)*E + r(3)*E.^2 + r(4)*E.^3;
[g_r] = CalcG(mean_RF',times_fuji);
[g_g] = CalcG(mean_GF',times_fuji);
[g_b] = CalcG(mean_BF',times_fuji);

%show powerfit results
figure()
subplot(3,1,1)
plot(t, mean_RF,'rx');
hold on
plot(t,t.^(1/g_r(2))*g_r(1),'r-');
hold off
title('Power Fit to Red Channel')
legend('Data', 'Gamma fit')
xlabel('Exposure [s]')
ylabel('Brightness [au]')

subplot(3,1,2)
plot(t, mean_GF,'gx');
hold on
plot(t,t.^(1/g_g(2))*g_g(1),'g-');
hold off
title('Power Fit to Green Channel')
legend('Data', 'Gamma fit')
xlabel('Exposure [s]')
ylabel('Brightness [au]')

subplot(3,1,3)
plot(t, mean_BF,'bx');
hold on
plot(t,t.^(1/g_b(2))*g_b(1),'b-');
hold off
title('Power Fit to Blue Channel')
legend('Data', 'Gamma fit')
xlabel('Exposure [s]')
ylabel('Brightness [au]')

%% Plot the linearized exposure data
%show powerfit results
figure()
subplot(3,1,1)
plot(t,mean_RF.^(g_r(2)),'r-');
title('Linearized Exposure Data for Red Channel')
xlabel('Exposure [s]')
ylabel('Brightness [au]')

subplot(3,1,2)
plot(t,mean_GF.^(g_g(2)),'g-');
title('Linearized Exposure Data for Green Channel')
xlabel('Exposure [s]')
ylabel('Brightness [au]')

subplot(3,1,3)
plot(t,mean_BF.^(g_b(2)),'b-');
title('Linearized Exposure Data for Blue Channel')
xlabel('Exposure [s]')
ylabel('Brightness [au]')

%% Normalize image data
fName = ('Mission Chapel/_DSF1678.JPG')
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

fName = ('Mission Chapel/_DSF1674.JPG')
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
