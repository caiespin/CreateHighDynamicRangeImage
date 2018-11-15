%===============================  HDR.m  ==================================
% Description:
%   Script to generate a High Dynamic Range image
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
clear all;
close all;

%% =========Calculate the Camera (Fuji X-E1) compression algorithm=========
[mean_RF, mean_BF, mean_GF, T, gain, Imfiles] = RadioCalData('G800',...
    [1600 830 300 300],true);

%Polinomial fitting
% [r_inv, g_inv, b_inv] = CalcPolCoef(mean_RF,mean_GF,mean_BF, T, true);
% scale = 255; 
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
subplot(3,3,1)
imshow(uint8(Pic1))
str = 'Base Picture (Exposed to the right)';
title(str)
subplot(3,3,2)
imshow(uint8(Pic2))
str = 'Middle Picture';
title(str)
subplot(3,3,3)
imshow(uint8(Pic3))
str = 'Lightest Picture';
title(str)
%---Plot Histograms of the channels of the linearized picture1 B'^g(a0T)--- 
subplot(3,3,4)
histogram(Pic1_lin(:,:,1),25,'EdgeColor','k','FaceColor','r')
axis([0 14.0*10^5 0 inf])
str = ['Base Picture B' char(39) '^g(a0T) of Red channel'];
title(str)
subplot(3,3,5)
histogram(Pic1_lin(:,:,2),25,'EdgeColor','k','FaceColor','g')
axis([0 14.0*10^5 0 inf])
str = ['Base Picture B' char(39) '^g(a0T) of Green channel'];
title(str)
subplot(3,3,6)
histogram(Pic1_lin(:,:,3),25,'EdgeColor','k','FaceColor','b')
axis([0 14.0*10^5 0 inf])
str = ['Base Picture B' char(39) '^g(a0T) of Blue channel'];
title(str)
%---Plot Histograms of the channels of the linearized picture2 B'^g(a1T)--- 
subplot(3,3,7)
histogram(Pic2_lin(:,:,1),25,'EdgeColor','k','FaceColor','r')
axis([0 14.0*10^5 0 inf])
str = ['Middle Picture B' char(39) '^g(a1T) of Red channel'];
title(str)
subplot(3,3,8)
histogram(Pic2_lin(:,:,2),25,'EdgeColor','k','FaceColor','g')
axis([0 14.0*10^5 0 inf])
str = ['Middle Picture B' char(39) '^g(a1T) of Green channel'];
title(str)
subplot(3,3,9)
histogram(Pic2_lin(:,:,3),25,'EdgeColor','k','FaceColor','b')
axis([0 14.0*10^5 0 inf])
str = ['Middle Picture B' char(39) '^g(a1T) of Blue channel'];
title(str)
%---Plot Histograms of the channels of the linearized picture2 B'^g(a2T)--- 
figure()
subplot(3,3,1)
histogram(Pic3_lin(:,:,1),25,'EdgeColor','k','FaceColor','r')
axis([0 14.0*10^5 0 inf])
str = ['Lightest Picture B' char(39) '^g(a2T) of Red channel'];
title(str)
subplot(3,3,2)
histogram(Pic3_lin(:,:,2),25,'EdgeColor','k','FaceColor','g')
axis([0 14.0*10^5 0 inf])
str = ['Lightest Picture B' char(39) '^g(a2T) of Green channel'];
title(str)
subplot(3,3,3)
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
subplot(3,3,4)
histogram(((Pic2_lin(:,:,1))/a(2)),25,'EdgeColor','k','FaceColor','r')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a1T)/a1 of Red channel'];
title(str)
subplot(3,3,5)
histogram(((Pic2_lin(:,:,2))/a(2)),25,'EdgeColor','k','FaceColor','g')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a1T)/a1 of Green channel'];
title(str)
subplot(3,3,6)
histogram(((Pic2_lin(:,:,3))/a(2)),25,'EdgeColor','k','FaceColor','b')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a1T)/a1 of Blue channel'];
title(str)
%------Histograms of the channels of the scaled picture2 B'^g(a2T)/a2------ 
subplot(3,3,7)
histogram(((Pic3_lin(:,:,1))/a(3)),25,'EdgeColor','k','FaceColor','r')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a2T)/a2 of Red channel'];
title(str)
subplot(3,3,8)
histogram(((Pic3_lin(:,:,2))/a(3)),25,'EdgeColor','k','FaceColor','g')
axis([0 2.0*10^5 0 inf])
str = ['Histogram B' char(39) '^g(a2T)/a2 of Green channel'];
title(str)
subplot(3,3,9)
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