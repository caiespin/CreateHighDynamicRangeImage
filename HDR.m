%HDRAC--HDR algorithm by Aaron and Carlos
clear all;
close all;

%% =========Calculate the Camera (Fuji X-E1) compression algorithm=========
[mean_RF, mean_BF, mean_GF, T, gain, Imfiles] = RadioCalData('G800',...
    [1600 830 300 300],true);
%Polinomial fitting
% [r_inv, g_inv, b_inv] = CalcPolCoef(mean_RF,mean_GF,mean_BF, T, true);
% scale = 255; 
%Exponential fitting B^g
%[gR, gG, gB] = CalcG2(mean_RF,mean_GF,mean_BF, T,true);

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
histogram(uint8(Pic1_lin(:,:,1)/sR1),25,'EdgeColor','k','FaceColor','r')
str = ['Base Picture B' char(39) '^g(a0T) of Red channel'];
title(str)
subplot(3,3,2)
histogram(uint8(Pic1_lin(:,:,2)/sG1),25,'EdgeColor','k','FaceColor','g')
str = ['Base Picture B' char(39) '^g(a0T) of Green channel'];
title(str)
subplot(3,3,3)
histogram(uint8(Pic1_lin(:,:,3)/sB1),25,'EdgeColor','k','FaceColor','b')
str = ['Base Picture B' char(39) '^g(a0T) of Blue channel'];
title(str)
%Plot Histograms of the channels of the linearized picture2 B'^g(a1T) 
subplot(3,3,4)
histogram(uint8(Pic2_lin(:,:,1)/sR2),25,'EdgeColor','k','FaceColor','r')
str = ['Middle Picture B' char(39) '^g(a1T) of Red channel'];
title(str)
subplot(3,3,5)
histogram(uint8(Pic2_lin(:,:,2)/sG2),25,'EdgeColor','k','FaceColor','g')
str = ['Middle Picture B' char(39) '^g(a1T) of Green channel'];
title(str)
subplot(3,3,6)
histogram(uint8(Pic2_lin(:,:,3)/sB2),25,'EdgeColor','k','FaceColor','b')
str = ['Middle Picture B' char(39) '^g(a1T) of Blue channel'];
title(str)
%Plot Histograms of the channels of the linearized picture2 B'^g(a2T) 
subplot(3,3,7)
histogram(uint8(Pic3_lin(:,:,1)/sR3),25,'EdgeColor','k','FaceColor','r')
str = ['Lightest Picture B' char(39) '^g(a2T) of Red channel'];
title(str)
subplot(3,3,8)
histogram(uint8(Pic3_lin(:,:,2)/sG3),25,'EdgeColor','k','FaceColor','g')
str = ['Lightest Picture B' char(39) '^g(a2T) of Green channel'];
title(str)
subplot(3,3,9)
histogram(uint8(Pic3_lin(:,:,3)/sB3),25,'EdgeColor','k','FaceColor','b')
str = ['Lightest Picture B' char(39) '^g(a2T) of Blue channel'];
title(str)
%% Scale by ratio of time
t = [1/1000;1/125;1/30];
a(1) = 1;
a(2) = t(2)/t(1); %scale factor between image two and one
a(3) = t(3)/t(1); %scale factor betweem image three and image one
%composition 1
comp1HDR = ImMerge1(Pic1_lin,Pic2_lin,Pic3_lin,a);
comp1 = tonemap(comp1HDR,'AdjustSaturation',2,'AdjustLightness',[0.2 1]);
figure()
comp1_rsize = imresize(comp1, 0.35);
imshow(comp1_rsize)
%% composition 2
Image = ImMerge2(Pic1_lin,Pic2_lin,Pic3_lin,a);
comp2 = tonemap(Image,'AdjustSaturation',2, 'AdjustLightness', [0.2 1]);
figure()
comp2_rsize = imresize(comp2, 0.35);
imshow(comp2_rsize)

% 
% ImLDR_g(:,:,1) = ImHDR(:,:,1).^(1/gR);
% ImLDR_g(:,:,2) = ImHDR(:,:,2).^(1/gG);
% ImLDR_g(:,:,3) = ImHDR(:,:,3).^(1/gB);
% figure
% subplot(2,3,1)
% imshow(uint8(ImHDR/scale))
% title('High Dynamic Range Result')
% subplot(2,3,4)
% imhist(uint8(ImHDR/scale))
% axis([0 255 0 2.0*10^6])
% subplot(2,3,2)
% imshow(uint8(ImLDR_t))
% title('Low Dynamic Range using tonemap')
% subplot(2,3,5)
% imhist(uint8(ImLDR_t))
% axis([0 255 0 2.0*10^6])
% subplot(2,3,3)
% imshow(uint8(ImLDR_g))
% title('Low Dynamic Range using B^{1/g}')
% subplot(2,3,6)
% imhist(uint8(ImLDR_g))
% axis([0 255 0 2.0*10^6])