function LoadTestImage()
clear all;
msg = imread('1.bmp');
figure(1);

imshow(msg);

%msg(1:70,1:1)=1;
%msg = img(:,:);

%{decodeMsg(size(msg,1),size(msg,2)) = 0;

decodeLine(1,size(msg,2)) = 0;
disp('msg');
disp(size(msg));

disp('decodeMsg');
disp(size(decodeMsg));
%}

for i = 1:size(msg,1)
    %disp(i);

    res = convenc(msg(1,:),poly2trellis(3,[6,7]));
    tb=5;
    decodeLine=vitdec(res,poly2trellis(3,[6,7]),tb,'trunc','hard');
    
    %disp('decodeLine');
    %disp(size(decodeLine));

    %decodeMsg = [decodeLine;decodeMsg];
    decodeMsg = [decodeMsg;decodeLine];
    
end
figure(2);
imshow(decodeMsg);

disp(sum(abs(decodeMsg-msg)));


%disp(res);

 
 
%disp(size(img));
%imshow(img);

%msg = img(:,:);


%test = convenc(img(:,:,:)),poly2trellis(3,[6,7]);


%{
p = 3;
xx3 = xx(1:p:end,1:p:end);

n1 = 1:size(xx3,2);
tti = 1: 1/3 : size(xx3,2);
xlinearrows = interp1(n1,xx3',tti)';%linearly interpolate rows
n2 = 1:size(xx3,1);
ttj = 1: 1/3 : size(xx3,1);
xlinear = interp1(n2,xlinearrows,ttj); %linearly interpolate columns
figure(4);
imshow(xlinear,[0 255]);
figure(5);
imshow(xx3,[0,255]);

figure(1);
plot(xx(1,:));
figure(2);
plot(xx3(1,:));
figure(3);
plot(xlinearrows(1,:));
%}

%pre part 7
%{
n1 = 0:6;
xr1 = (-2).^n1;
tti = 0:0.1:6; %locations between the n1 indices
xr1linear = interp1(n1,xr1,tti); %interpolate
stem(tti,xr1linear);
%}

%part 5 and 6
%{
L = length(xx3(1,:));
nn = ceil((0.999:1:3*L)/3); %round up to the next integer
H = length(xx3(:,1));
mm = ceil((0.999:1:3*H)/3); %round up to the next integer
xholdrows = xx3(:,nn); %part 5
xhold = xholdrows(mm,:); %part 6

figure(1);
imshow(xx,[0 255]);
figure(2);
imshow(xx3,[0 255]);
figure(3);
imshow(xholdrows,[0 255]); %part 5
figure(4);
imshow(xhold,[0 255]); %part 6
%}

%part 4
%{
figure(1);
plot(xx3(1,:));
figure(2);
plot(xholdrows(1,:));
figure(3);
plot(xx(1,:));
%}

%part 3
%{
xr1 = (-2).^(0:6); %a made up signal
L = length(xr1);
nn = ceil((0.999:1:4*L)/4); %round up to the next integer
xr1hold = xr1(nn);

figure(1);
plot(xr1);
figure(2);
plot(xr1hold);

disp (size(xr1));
disp(size(xr1hold));
%plot((0:6),xr1,'b-',(0:6),xr1hold,'r-');
%}

%chirp aliasing example
%{ 
figure(1);
t = 0:0.01:5;
x = cos(2*pi*t.^2);
plot(t,x);

figure(2);
y = x(1:10:end); %samples every 0.01*10 = 1 second
t2 = 0:0.1:5;
plot(t2,y);

figure(3);
plot(t,x,'b-',t2,y,'r-');
%}