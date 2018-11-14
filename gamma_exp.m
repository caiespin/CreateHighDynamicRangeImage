%Gamma experiment
clear all;
close all;
x_min = 2650;
x_max = 2750;
y_min = 1300;
y_max = 1400;
times_sony = [1/125;1/160;1/160;1/200;1/250;1/320;1/400;1/500;1/640;1/800;1/1000;1/1250;1/1600;1/2000];

baseFN = 373;
baseFName = 'Gamma_img/DSC00';
fext = '.JPG';
files = 387-374;
for file = 1:files+1
    FN = baseFN+file;
    FNstr = num2str(FN);
    fName = strcat(baseFName,FNstr,fext);
    pic = imread(fName);
    mask = pic(y_min:y_max,x_min:x_max,:);
    R = mask(:,:,1);
    G = mask(:,:,2);
    B = mask(:,:,3);
    mean_R(file) = mean2(R);
    mean_G(file) = mean2(G);
    mean_B(file) = mean2(B);
end

%% Calculate the Fuji X-E2 compression algorithm
%filename base string
baseFujiFName = 'Gamma_img/FUJI/_DSF16';
%extension string
fext = '.JPG';
%which files to use
baseFujiFN = 87-1;
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
%Show all the images for linearization experiments.


figure()
% subplot(2,1,1)
% plot(times_sony,mean_R,'r--x')
% hold on
% plot(times_sony,mean_G, 'g--x')
% plot(times_sony,mean_B, 'b--x')
% hold off
% title('Sony Camera Compression Data')
% xlabel('Exposure time [sec]')
% ylabel('Brightness [au]')
% legend('Red','Blue','Green')
% subplot(2,1,2)
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
%% Calculate the compression algorithm
%for the Fuji camera:
t = times_fuji;
E = t/max(t); %normalize exposure to 1 for max t
%fit each channel separately
%blue channel
y = mean_BF';
A = zeros(length(E),4);
for i = 1:length(E)
    A(i,:) = [1,E(i),E(i)^2,E(i)^3];
end
gammaFun = @(x,E)x(1)*E.^(1/x(2));
x0 = [40 1];
gamma_fit = lsqcurvefit(gammaFun,x0,E,mean_RF')
%use least squares fit to find polynomial coefficients
b = A\y;
%red channel
y = mean_RF';
r = A\y;
%green channel
y = mean_GF';
g = A\y;
%calculate interpolation vector
e = zeros(255,1);
for i = 1:255
    e(i) = i/255;
    r_e(i) = pixel_fit(e(i),1,r,g,b,1);
    g_e(i) = pixel_fit(e(i),2,r,g,b,1);
    b_e(i) = pixel_fit(e(i),3,r,g,b,1);
end


%test an inverse function given e input vector and r_e data
%in other words e = Bx
B_inv = zeros(255, 4);
G_inv = B_inv;
R_inv = B_inv;

for i = 1:255
    R_inv(i,:) = [1 r_e(i) r_e(i)^2 r_e(i)^3];
    G_inv(i,:) = [1 g_e(i) g_e(i)^2 g_e(i)^3];
    B_inv(i,:) = [1 b_e(i) b_e(i)^2 b_e(i)^3];
end
r_inv = R_inv\e
g_inv = G_inv\e
b_inv = B_inv\e

r_lin = r_inv(1) + r_inv(2)*mean_RF + r_inv(3)*mean_RF.^2 + r_inv(4)*mean_RF.^3;
g_lin = g_inv(1) + g_inv(2)*mean_GF + g_inv(3)*mean_GF.^2 + r_inv(4)*mean_GF.^3;



%% Calc Linearization Parameters
fit_lin = r(1) + r(2)*E + r(3)*E.^2 + r(4)*E.^3;
[g_r] = CalcG(mean_RF',times_fuji);
[g_g] = CalcG(mean_GF',times_fuji);
[g_b] = CalcG(mean_BF',times_fuji);

%show different linearization results
figure()
plot(E, mean_RF,'rx');
hold on

plot(E,fit_lin,'b-');
plot(E,r_lin*255,'g-o')
plot(E,g_lin*255,'g-o')

hold off
title('Polynomial Fit to Red Channel')
legend('Data','Poly fit','Linear(poly)')
xlabel('Normalized Exposure [au]')
ylabel('Brightness [au]')
scale = 255; 
for i = 1:length(t)
    R_lin(i) =E(i)*scale* mean_RF(i)/fit_lin(i);
end
glinData = mean_RF.^(g(2)*1.0);
glinData = glinData/max(glinData) * 255;

%plot an example of the linearization function along with original data
% figure(4)
% plot(E,mean_RF,'rx')
% hold on
% plot(E,R_lin,'r-')
% plot(E,glinData,'k-x')
% hold off
% title('Linearized Red Channel Data')
% legend('Data', 'Linearized','gamma linearized')
% xlabel('Normalized Exposure [au]')
% ylabel('Brightness [au]')

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
%% composition 2
Image = ImMerge2(Pic1_lin,Pic2_lin,Pic3_lin,a);
comp2 = tonemap(Image,'AdjustSaturation',2.5, 'AdjustLightness', [0.15 1]);
figure()
comp2_rsize = imresize(comp2, 0.35);
imshow(comp2_rsize)

