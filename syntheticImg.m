function syntheticImg()
clear all;

%xpix = ones(256,1)*cos(2*pi*(0:255)/16);
xpix = ones(1,400).*(cos(2*pi*(0:399)/50)).';


mesh(xpix);
colormap(gray);
ylabel('Row Index');
xlabel('Column Index');
zlabel('Magnitude');