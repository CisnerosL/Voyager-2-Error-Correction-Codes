function displighthouse()
clear all;
load('1');
figure(1);
imshow(xx,[0 255]);
figure(2);
plot(xx(200,:));

%imshow()
%pic = imread('ngc6543a.jpg');
%imshow(pic);

%{
    load mandrill;
    image(X);
    mesh(X);
    colormap(gray);
    xlabel('Row Index');
    ylabel('Colomn Index');
    zlabel('Magnitude');
%}