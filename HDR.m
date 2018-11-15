%===============================  HDR.m  ==================================
% Description:
%   Script to generate a High Dynamic Range images
%
%   Input arguments:
%      -Pictures stack files for Radiometric calibration located in a  
%       folder on thesame directory as the script. The files must have 
%       the following naming convention: 
%               G<ISO Gain>_<Exposure time denominator>
%      -Pictures Stack that will be used to generate the HDR image.
%
% Output:
%   Low Dynamic Range Image usint two composition methods 
% -------------------------------------------------------------------------
%   Version   : 1.1
%   Authors   : Aaron Hunter and Carlos Espinosa
%   Created   : 11.14.18
% -------------------------------------------------------------------------
clc
clear all;
close all;

%% =========Calculate the Camera (Fuji X-E1) compression algorithm=========
[mean_RF, mean_BF, mean_GF, T, gain, Imfiles] = RadioCalData('G800',...
    [1600 830 300 300],true);
%Exponential fitting B^g
[gR, gG, gB] = CalcG2(mean_RF,mean_GF,mean_BF, T,true);

%% =======================Linearize image data=============================
%Linearize Base picture (Exposed to the right) using B^g
fName = ('Mission Chapel/_DSF1678.JPG');
Pic1 = imread(fName);
[Pic1_lin(:,:,1), gR, sR1] = Linearization(Pic1(:,:,1), mean_RF, T);
[Pic1_lin(:,:,2), gG, sG1] = Linearization(Pic1(:,:,2), mean_GF, T);
[Pic1_lin(:,:,3), gB, sB1] = Linearization(Pic1(:,:,3), mean_BF, T);
%Linearize picture 2 Middle picture using B^g
fName = ('Mission Chapel/_DSF1674.JPG');
Pic2 = imread(fName);
[Pic2_lin(:,:,1), gR, sR2] = Linearization(Pic2(:,:,1), mean_RF, T);
[Pic2_lin(:,:,2), gG, sG2] = Linearization(Pic2(:,:,2), mean_GF, T);
[Pic2_lin(:,:,3), gB, sB2] = Linearization(Pic2(:,:,3), mean_BF, T);
%Linearize picture 3 lightest picture using B^g
fName = ('Mission Chapel/_DSF1676.JPG');
Pic3 = imread(fName);
[Pic3_lin(:,:,1), gR, sR3] = Linearization(Pic3(:,:,1), mean_RF, T);
[Pic3_lin(:,:,2), gG, sG3] = Linearization(Pic3(:,:,2), mean_GF, T);
[Pic3_lin(:,:,3), gB, sB3] = Linearization(Pic3(:,:,3), mean_BF, T);

%% ================Plot original Pictures and histograms=================== 
%---------------------------Plot selected pictures-------------------------
figure()
subplot(1,3,1)
imshow(uint8(Pic1))
str = 'Base Picture (Exposed to the right)';
title(str)
subplot(1,3,2)
imshow(uint8(Pic2))
str = 'Middle Picture';
title(str)
subplot(1,3,3)
imshow(uint8(Pic3))
str = 'Lightest Picture';
title(str)
%---Plot Histograms of the channels of the linearized picture1 B'^g(a0T)--- 
figure()
subplot(3,3,1)
histogram(Pic1_lin(:,:,1),25,'EdgeColor','k','FaceColor','r')
axis([0 14.0*10^5 0 inf])
str = ['Base Picture B' char(39) '^g(a0T) of Red channel'];
title(str)
subplot(3,3,2)
histogram(Pic1_lin(:,:,2),25,'EdgeColor','k','FaceColor','g')
axis([0 14.0*10^5 0 inf])
str = ['Base Picture B' char(39) '^g(a0T) of Green channel'];
title(str)
subplot(3,3,3)
histogram(Pic1_lin(:,:,3),25,'EdgeColor','k','FaceColor','b')
axis([0 14.0*10^5 0 inf])
str = ['Base Picture B' char(39) '^g(a0T) of Blue channel'];
title(str)
%---Plot Histograms of the channels of the linearized picture2 B'^g(a1T)--- 
subplot(3,3,4)
histogram(Pic2_lin(:,:,1),25,'EdgeColor','k','FaceColor','r')
axis([0 14.0*10^5 0 inf])
str = ['Middle Picture B' char(39) '^g(a1T) of Red channel'];
title(str)
subplot(3,3,5)
histogram(Pic2_lin(:,:,2),25,'EdgeColor','k','FaceColor','g')
axis([0 14.0*10^5 0 inf])
str = ['Middle Picture B' char(39) '^g(a1T) of Green channel'];
title(str)
subplot(3,3,6)
histogram(Pic2_lin(:,:,3),25,'EdgeColor','k','FaceColor','b')
axis([0 14.0*10^5 0 inf])
str = ['Middle Picture B' char(39) '^g(a1T) of Blue channel'];
title(str)
%---Plot Histograms of the channels of the linearized picture2 B'^g(a2T)--- 
subplot(3,3,7)
histogram(Pic3_lin(:,:,1),25,'EdgeColor','k','FaceColor','r')
axis([0 14.0*10^5 0 inf])
str = ['Lightest Picture B' char(39) '^g(a2T) of Red channel'];
title(str)
subplot(3,3,8)
histogram(Pic3_lin(:,:,2),25,'EdgeColor','k','FaceColor','g')
axis([0 14.0*10^5 0 inf])
str = ['Lightest Picture B' char(39) '^g(a2T) of Green channel'];
title(str)
subplot(3,3,9)
histogram(Pic3_lin(:,:,3),25,'EdgeColor','k','FaceColor','b')
axis([0 14.0*10^5 0 inf])
str = ['Lightest Picture B' char(39) '^g(a2T) of Blue channel'];
title(str)

%% ===================Scale pictures by a ratio of time====================
t = [1/1000;1/125;1/30];
a(1) = 1;
a(2) = t(2)/t(1); %scale factor between image two and one
a(3) = t(3)/t(1); %scale factor betweem image three and image one
%---------------Plot Histograms of the scaled picture channels-------------
figure()
subplot(3,3,1)
histogram(((Pic2_lin(:,:,1))/a(2)),25,'EdgeColor','k','FaceColor','r')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a1T)/a1 of Red channel'];
title(str)
subplot(3,3,2)
histogram(((Pic2_lin(:,:,2))/a(2)),25,'EdgeColor','k','FaceColor','g')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a1T)/a1 of Green channel'];
title(str)
subplot(3,3,3)
histogram(((Pic2_lin(:,:,3))/a(2)),25,'EdgeColor','k','FaceColor','b')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a1T)/a1 of Blue channel'];
title(str)
%------Histograms of the channels of the scaled picture2 B'^g(a2T)/a2------ 
subplot(3,3,4)
histogram(((Pic3_lin(:,:,1))/a(3)),25,'EdgeColor','k','FaceColor','r')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a2T)/a2 of Red channel'];
title(str)
subplot(3,3,5)
histogram(((Pic3_lin(:,:,2))/a(3)),25,'EdgeColor','k','FaceColor','g')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a2T)/a2 of Green channel'];
title(str)
subplot(3,3,6)
histogram(((Pic3_lin(:,:,3))/a(3)),25,'EdgeColor','k','FaceColor','b')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a2T)/a2 of Blue channel'];
title(str)

%% =======================Create Composite Images==========================
%------------------------------composition 1-------------------------------
comp1HDR = ImMerge1(Pic1_lin,Pic2_lin,Pic3_lin,a,false);
comp1 = tonemap(comp1HDR,'AdjustSaturation',2,'AdjustLightness',[0.2 1]);
%------------------------------composition 2-------------------------------
comp2HDR = ImMerge2(Pic1_lin,Pic2_lin,Pic3_lin,a,false);
comp2 = tonemap(comp2HDR,'AdjustSaturation',2, 'AdjustLightness', [0.2 1]);

comp1_rsize = imresize(comp1, 0.35);
comp2_rsize = imresize(comp2, 0.35);
%% ======================Plot Pictures and histograms====================== 
%---------------Plot HDR images Composition 1 and Composition 2------------
figure()
subplot(1,2,1)
imshow(comp1_rsize)
str = 'HDR 1';
title(str)
subplot(1,2,2)
imshow(comp2_rsize)
str = 'HDR 2';
title(str)
%---------------Plot Histograms Composition 1 and Composition 2------------
figure()
subplot(3,3,1)
histogram(((Pic2_lin(:,:,1))/a(2)),25,'EdgeColor','k','FaceColor','r')
str = 'HDR 1 Histogram of the Red channel';
title(str)
subplot(3,3,2)
histogram(((Pic2_lin(:,:,2))/a(2)),25,'EdgeColor','k','FaceColor','g')
str = 'HDR 1 Histogram of the Red channel';
title(str)
subplot(3,3,3)
histogram(((Pic2_lin(:,:,3))/a(2)),25,'EdgeColor','k','FaceColor','b')
str = 'HDR 1 Histogram of the Red channel';
title(str)
%------Histograms of the channels of the scaled picture2 B'^g(a2T)/a2------ 
subplot(3,3,4)
histogram(((Pic3_lin(:,:,1))/a(3)),25,'EdgeColor','k','FaceColor','r')
str = 'HDR 2 Histogram of the Red channel';
title(str)
subplot(3,3,5)
histogram(((Pic3_lin(:,:,2))/a(3)),25,'EdgeColor','k','FaceColor','g')
str = 'HDR 2 Histogram of the Red channel';
title(str)
subplot(3,3,6)
histogram(((Pic3_lin(:,:,3))/a(3)),25,'EdgeColor','k','FaceColor','b')
str = 'HDR 2 Histogram of the Red channel';
title(str)

%============================HELPER FUNCTIONS==============================
%==============================RadioCalData================================
function [mean_R, mean_G, mean_B, T, gain, Imfiles] = RadioCalData(fdire,window,verbose)
if ~ischar(fdire)
    error('Input must be a string of the root directory of the files')
end
%-------------Walk pictures folder directory--------------
fileNames = dir(fdire);
fileNames = fileNames(~cellfun('isempty', {fileNames.name}));
[m,n] = size(fileNames);
files = strings([1,m]);
Imfiles = strings;
gain = strings;
T = strings;
for c = 1:m
    if strfind(fileNames(c).name,'G')
        files(c) = fileNames(c).name;
        if strlength(files(c)) > 1
          values = strsplit(files(c),{'G','_','.'});
          gain = values(2);
          values(3) = ' '+values(3);
          T = strcat(T,values(3));
          files(c) = ' '+files(c);
          Imfiles = strcat(Imfiles,files(c));
        end
    end
end
Imfiles = strsplit(Imfiles,' ');
Imfiles(1) = [];
T = strsplit(T,' ');
T(1) = [];
T = double(T).^-1;
gain = double(gain);
%-----------------Define crop section--------------------
[m,fnum] = size(Imfiles);
if  ischar(window)
    fName = char(strcat(fdire,'/',Imfiles(1)));
    [m,n,d] = size(imread(fName));
    rect = [round((m-200)/2) round((n-200)/2) 100 100];
end
if ~ischar(window) && isempty(window)
    cI = round(fnum/2);
    fName = char(strcat(fdire,'/',Imfiles(cI)));
    pic = imread(fName);
    fcrop = figure('Name','Define Mask Window Section')
    [J, rect] = imcrop(pic);
    rect
    close(fcrop)
end
if ~ischar(window) && ~isempty(window)
    rect = window;
end
%----------------------Read Images-----------------------
%f2 = figure('Name','Flat surface pictures data set')
for file = 1:fnum
    fName = char(strcat(fdire,'/',Imfiles(file)));
    pic = imread(fName);
    mask = imcrop(pic,rect);
    R = mask(:,:,1);
    G = mask(:,:,2);
    B = mask(:,:,3);
    mean_R(file) = mean2(R);
    mean_G(file) = mean2(G);
    mean_B(file) = mean2(B);
end

RadPic1 = imread(char(strcat(fdire,'/',Imfiles(1))));
square1 = imcrop(RadPic1,rect);
RadPic2 = imread(char(strcat(fdire,'/',Imfiles(2))));
square2 = imcrop(RadPic2,rect);
RadPic3 = imread(char(strcat(fdire,'/',Imfiles(3))));
square3 = imcrop(RadPic3,rect);
RadPic4 = imread(char(strcat(fdire,'/',Imfiles(4))));
square4 = imcrop(RadPic4,rect);
RadPic5 = imread(char(strcat(fdire,'/',Imfiles(5))));
square5 = imcrop(RadPic5,rect);
RadPic6 = imread(char(strcat(fdire,'/',Imfiles(6))));
square6 = imcrop(RadPic6,rect);
RadPic7 = imread(char(strcat(fdire,'/',Imfiles(7))));
square7 = imcrop(RadPic7,rect);

%----------Walk pictures stack folder directory----------
fileNames1 = dir('Mission Chapel');
fileNames1 = fileNames1(~cellfun('isempty', {fileNames1.name}));
[m,n] = size(fileNames1);
files1 = strings([1,m]);
Imfiles1 = strings;
count = 1;
for c = 1:m
    files1(c) = fileNames1(c).name;
    if contains(files1(c),'D')
       Imfiles1(count) = files1(c);
       count = count + 1;
    end
end
I_1 = imread(char(strcat('Mission Chapel','/',Imfiles1(3))));%1/30
I_2 = imread(char(strcat('Mission Chapel','/',Imfiles1(2))));%1/60
I_3 = imread(char(strcat('Mission Chapel','/',Imfiles1(1))));%1/125
I_4 = imread(char(strcat('Mission Chapel','/',Imfiles1(4))));%1/500
I_5 = imread(char(strcat('Mission Chapel','/',Imfiles1(5))));%1/1000
I_6 = imread(char(strcat('Mission Chapel','/',Imfiles1(6))));%1/4000

ExposureTimes = [1/2000 1/1000 1/500 1/125 1/60 1/30];
ExposureTimes = flip(ExposureTimes);
%----------------------Print-----------------------
if verbose
figure()
%subplot(2,1,1)
plot(T,mean_R, 'r--x')
hold on
plot(T,mean_B, 'b--x')
plot(T,mean_G, 'g--x')
hold off
title('Fuji X-E2 Camera Compression Data')
xlabel('Exposure time [sec]')
ylabel('Brightness [au]')
legend('Red','Blue','Green')
%-------Print Radiometric Calibration Stack---------
figure()
subplot(1,7,1)
imshow(square1)
str = sprintf('G: %d T: %0.5f sec', gain, T(1));
title(str)
subplot(1,7,2)
imshow(square2)
str = sprintf('G: %d T: %0.5f sec', gain, T(2));
title(str)
subplot(1,7,3)
imshow(square3)
str = sprintf('G: %d T: %0.5f sec', gain, T(3));
title(str)
subplot(1,7,4)
imshow(square4)
str = sprintf('G: %d T: %0.5f sec', gain, T(4));
title(str)
subplot(1,7,5)
imshow(square5)
str = sprintf('G: %d T: %0.5f sec', gain, T(5));
title(str)
subplot(1,7,6)
imshow(square6)
str = sprintf('G: %d T: %0.5f sec', gain, T(6));
title(str)
subplot(1,7,7)
imshow(square7)
str = sprintf('G: %d T: %0.5f sec', gain, T(7));
title(str)
%-------------Print Images Stack-------------------
figure
subplot(3,4,1)
threshold_mask = not(rgb2gray(I_1) == 255);
prom = (nnz(not(threshold_mask))/nnz(threshold_mask))*100;
imshow(I_1.*uint8(threshold_mask))
str = sprintf('Gain: %d Exposure Time: %0.3f sec', gain, ExposureTimes(1));
title(str)
subplot(3,4,2)
histogram(I_1)
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
histogram(I_2)
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
histogram(I_3)
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
histogram(I_4)
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
histogram(I_5)
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
histogram(I_6)
axis([0 255 0 1.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

end
end
%=================================CalG2====================================
function [gR, gG, gB] = CalcG2(mean_RF,mean_GF,mean_BF, T,verbose)
    fun = @(x,T)x(1)*T.^(1/x(2));
    x0 = [1600,1.5];
    r = lsqcurvefit(fun,x0,T,mean_RF);
    gR = r(2);
    g = lsqcurvefit(fun,x0,T,mean_GF);
    gG = g(2);
    b = lsqcurvefit(fun,x0,T,mean_BF);
    gB = b(2);
    if verbose
    figure('Name','Camera Compression Data Linearized');
    plot(T,(mean_RF.^gR)/(255^gR/255),'r--x')
    hold on
    plot(T,(mean_BF.^gG)/(255^gG/255), 'b--x')
    plot(T,(mean_GF.^gB)/(255^gB/255), 'g--x')
    hold off
    title('Camera Compression Data Linearized (B^g) and scaled')
    xlabel('Exposure time [sec]')
    ylabel('Brightness [au]')
    legend('Red','Blue','Green')
    end
end
%=============================Linearization================================
function [Im_Lin, g, scale] = Linearization(I, mean_vals, T)
    fun = @(x,T)x(1)*T.^(1/x(2));
    x0 = [1600,1.5];
    x = lsqcurvefit(fun,x0,T,mean_vals);
    I = double(I);
    g = x(2);
    scale = 255^g/255;
    Im_Lin = I.^g;
end
%================================ImMerge1==================================
function Image  = ImMerge1(im1,im2,im3,a,verbose)
E_max = max(max(im1));
mask = im1>= E_max/a(2);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
mask1 = mask;

%mask the lowest exposure pixels
mask = im1 < E_max/a(3);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
mask3 = mask;

%mask two is the inverse of mask1 and mask3
mask2 = not(mask1) .* not(mask3);

Image1 = (im1.*mask1);
Image2 = (im2.*mask2/a(2));
Image3 = ((im3.*mask3)/a(3));

if verbose
    figure()
    subplot(1,4,1)
    imshow(uint8(mask1*255));
    subplot(1,4,2)
    imshow(uint8(mask2*255));
    subplot(1,4,3)
    imshow(uint8(mask3*255));
    subplot(1,4,4)
    imshow(uint8(mask1 + mask2 + mask3)*255)
end
Image = Image1 + Image2 + Image3;
end
%================================ImMerge1==================================
function Image  = ImMerge2(im1,im2,im3,a,verbose)
E_max = max(max(im1));
mask = im1> E_max/a(2);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
%mask for the first image where it has the highest exposure pixels 
mask1 = mask;

mask = im1 < E_max/a(3);
maskAll = mask(:,:,1).*mask(:,:,2).*mask(:,:,3);
mask(:,:,1) = double(maskAll);
mask(:,:,2) = double(maskAll);
mask(:,:,3) = double(maskAll);
mask3 = mask;

mask2 = not(mask1) .* not(mask3);

Image1 = (im1.*mask1);
Image2 = (im1.*mask2 + im2.*mask2/a(2))/2;
Image3 = (im1.*mask3 + (im2.*mask3)/a(2) +(im3.*mask3)/a(3))/3;

if verbose
    figure()
    subplot(1,4,1)
    imshow(uint8(mask1*255));
    subplot(1,4,2)
    imshow(uint8(mask2*255));
    subplot(1,4,3)
    imshow(uint8(mask3*255));
    subplot(1,4,4)
    imshow(uint8(mask1 + mask2 + mask3)*255)
end

Image = Image1 + Image2 + Image3;
end
