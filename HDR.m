clc
clear all
close all
%% Calculate the Fuji X-E1 compression algorithm
%filename base string
baseFujiFName = 'Gamma_img/FUJI/_DSF16';
%extension string
fext = '.JPG';
%which files to use
baseFujiFN = 87-1;
x_min = 1600;
y_min = 1200;
files = 93-87; %number of files
%times_fuji = [1/30;1/60;1/125;1/250;1/500;1/1000]; %exposure data

times_fuji = [1/4000;1/2000;1/1000;1/500;1/250;1/125;1/60];
for file = 1:files+1
    %choose the file based on the index
    FN = baseFujiFN+file;
    FNstr = num2str(FN);
    %calculate the filename
    fName = strcat(baseFujiFName,FNstr,fext);
    %read image data
    pic = imread(fName);
    %mask off central white portion
    mask = imcrop(pic,[x_min y_min,100,100]);
    %split into channels
    RF = mask(:,:,1);
    GF = mask(:,:,2);
    BF = mask(:,:,3);
    %calculate mean brightness
    mean_RF(file) = mean2(RF);
    mean_GF(file) = mean2(GF);
    mean_BF(file) = mean2(BF);
end
figure(1)
subplot(2,1,1)
plot(times_fuji,mean_RF,'r--x')
hold on
plot(times_fuji,mean_BF, 'b--x')
plot(times_fuji,mean_GF, 'g--x')
hold off
title('Fuji X-E2 Camera Compression Data')
xlabel('Exposure time [sec]')
ylabel('Brightness [au]')
legend('Red','Blue','Green')
%% Linearize image data
%=====Base Image=======
%fName = ('Mission Chapel/_DSF1678.JPG')
fName = ('Bike/_DSF1700.JPG');%1/4
Pic1 = imread(fName);
[Pic1_Lin(:,:,1), gR, sR] = Linearization(Pic1(:,:,1), mean_RF, times_fuji');
[Pic1_Lin(:,:,2), gG, sG] = Linearization(Pic1(:,:,2), mean_GF, times_fuji');
[Pic1_Lin(:,:,3), gB, sB] = Linearization(Pic1(:,:,3), mean_BF, times_fuji');
scale = max([sR sG sB]);

subplot(2,1,2)
plot(times_fuji,(mean_RF.^gR)/scale,'r--x')
hold on
plot(times_fuji,(mean_BF.^gR)/scale, 'b--x')
plot(times_fuji,(mean_GF.^gR)/scale, 'g--x')
hold off
title('Fuji X-E2 Camera Compression Data Linearized (B^g) and scaled')
xlabel('Exposure time [sec]')
ylabel('Brightness [au]')
legend('Red','Blue','Green')

%=====Image 2========
%fName = ('Mission Chapel/_DSF1674.JPG');
fName = ('Bike/_DSF1702.JPG');%1/15
Pic2 = imread(fName);
[Pic2_Lin(:,:,1), gR, sR] = Linearization(Pic2(:,:,1), mean_RF, times_fuji');
[Pic2_Lin(:,:,2), gG, sG] = Linearization(Pic2(:,:,2), mean_GF, times_fuji');
[Pic2_Lin(:,:,3), gB, sB] = Linearization(Pic2(:,:,3), mean_BF, times_fuji');
scale = max([sR sG sB]);
%=====Image 3========
%fName = ('Mission Chapel/_DSF1675.JPG');
fName = ('Bike/_DSF1704.JPG');%1/60
Pic3 = imread(fName);
[Pic3_Lin(:,:,1), gR, sR] = Linearization(Pic3(:,:,1), mean_RF, times_fuji');
[Pic3_Lin(:,:,2), gG, sG] = Linearization(Pic3(:,:,2), mean_GF, times_fuji');
[Pic3_Lin(:,:,3), gB, sB] = Linearization(Pic3(:,:,3), mean_BF, times_fuji');
scale = max([sR sG sB]);
%=======Plot original images vs linearized images=====
figure
subplot(2,3,1)
imshow(uint8(Pic1))
title('Original base image')
subplot(2,3,2)
imshow(uint8(Pic2))
title('Original Image 2')
subplot(2,3,3)
imshow(uint8(Pic3))
title('Original Image 3')
subplot(2,3,4)
imshow(uint8(Pic1_Lin/scale))
title('Linearized base image')
subplot(2,3,5)
imshow(uint8(Pic2_Lin/scale))
title('Linearized Image 2')
subplot(2,3,6)
imshow(uint8(Pic3_Lin/scale))
title('Linearized Image 3')

%% Scale by ratio of time
%t = [1/1000;1/125;1/60];%Mission Chapel

t = [1/60;1/15;1/4];%Bike

a(1) = 1;
a(2) = t(2)/t(1); %scale factor between image two and one
a(3) = t(3)/t(1); %scale factor betweem image three and image one
%composition 1
ImHDR = MergeIm(Pic1_Lin,Pic2_Lin,Pic3_Lin,a,scale);

%% Tonemap image
%============tonemap Mission Chapel=============
% ImLDR_t = tonemap((ImHDR/scale),'AdjustSaturation', 3.3);
% ImLDR_t = ImLDR_t./1.2; %reduce brightess (just a little bit)
%=================tonemap Bike==================
ImLDR_t = tonemap((ImHDR/scale),'AdjustSaturation', 2.5);

ImLDR_g(:,:,1) = ImHDR(:,:,1).^(1/gR);
ImLDR_g(:,:,2) = ImHDR(:,:,2).^(1/gG);
ImLDR_g(:,:,3) = ImHDR(:,:,3).^(1/gB);
figure
subplot(2,3,1)
imshow(uint8(ImHDR/scale))
title('High Dynamic Range Result')
subplot(2,3,4)
imhist(uint8(ImHDR/scale))
axis([0 255 0 2.0*10^6])
subplot(2,3,2)
imshow(uint8(ImLDR_t))
title('Low Dynamic Range using tonemap')
subplot(2,3,5)
imhist(uint8(ImLDR_t))
axis([0 255 0 2.0*10^6])
subplot(2,3,3)
imshow(uint8(ImLDR_g))
title('Low Dynamic Range using B^{1/g}')
subplot(2,3,6)
imhist(uint8(ImLDR_g))
axis([0 255 0 2.0*10^6])