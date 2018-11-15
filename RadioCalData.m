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
imhist(I_1)
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
imhist(I_2)
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
imhist(I_3)
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
imhist(I_4)
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
imhist(I_5)
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
imhist(I_6)
axis([0 255 0 1.0*10^6])
str = sprintf('Saturated pixels: %0.3f %% ', prom);
title(str)

end
end
