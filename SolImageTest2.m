I = uint8(imread('earf.png'));
imageDim = size(I);
snr = 15; %dB?

noisyI = awgn(double(I), 0.5);
subplot(2,2,[1 3]);
imshow(uint8(I(:,:,1)));

redBin = uint8(dec2bin(I(:,:,1)) - '0');
redBin = reshape(redBin, 1, []);
%------------------------------------------% New Code

GF = gf(msg,8,285); %primPoly: 285 = 100011101

msg = zeros(1,5120080);
msg = reshape(msg,[],1784);

rsenc(GF,2040,1784);

