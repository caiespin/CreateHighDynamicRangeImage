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
    f1 = figure('Name','Define Mask Window Section')
    [J, rect] = imcrop(pic);
    rect
    close(f1)
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
%----------------------Print-----------------------
if verbose
f2 = figure('Name','Camera Compression Data');
%subplot(2,1,1)
plot(T,mean_R,'r--x')
hold on
plot(T,mean_B, 'b--x')
plot(T,mean_G, 'g--x')
hold off
title('Fuji X-E2 Camera Compression Data')
xlabel('Exposure time [sec]')
ylabel('Brightness [au]')
legend('Red','Blue','Green')
end
end
