function dispimgmesh()
clear all;
load mandrill;
%image(X);
mesh(X);
colormap(gray);
xlabel('Row Index');
ylabel('Colomn Index');
zlabel('Magnitude');