function [r_inv, g_inv, b_inv] = CalcPolCoef(mean_RF,mean_GF,mean_BF, T)
E = T;
% [m,n] = size(T)
% E(n+1) = 1;%normalize exposure to 1 for max t
% mean_RF(n+1) = 1;
% mean_GF(n+1) = 1;
% mean_BF(n+1) = 1;
%fit each channel separately
%blue channel
y = mean_BF';
A = zeros(length(E),4);
for i = 1:length(E)
    A(i,:) = [1,E(i),E(i)^2,E(i)^3];
end
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
r_inv = R_inv\e;
g_inv = G_inv\e;
b_inv = B_inv\e;

r_lin = r_inv(1) + r_inv(2)*mean_RF + r_inv(3)*mean_RF.^2 + r_inv(4)*mean_RF.^3;
g_lin = g_inv(1) + g_inv(2)*mean_GF + g_inv(3)*mean_GF.^2 + g_inv(4)*mean_GF.^3;
b_lin = b_inv(1) + b_inv(2)*mean_BF + b_inv(3)*mean_BF.^2 + b_inv(4)*mean_BF.^3;


fit_lin = r(1) + r(2)*E + r(3)*E.^2 + r(4)*E.^3;

%show different linearization results
figure()
% plot(E, mean_RF,'rx');
hold on
%plot(E,fit_lin,'k-');
plot(E,r_lin,'r-o')
plot(E,g_lin,'g-o')
plot(E,b_lin,'b-o')
hold off
title('Polynomial Fit to Red Channel')
legend('Data','Poly fit','Linear(poly)')
xlabel('Normalized Exposure [au]')
ylabel('Brightness [au]')


scale = 255; 
for i = 1:length(T)
    R_lin(i) =E(i)*scale* mean_RF(i)/fit_lin(i);
end
glinData = mean_RF.^(g(2)*1.0);
glinData = glinData/max(glinData) * 255;

% %plot an example of the linearization function along with original data
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

end