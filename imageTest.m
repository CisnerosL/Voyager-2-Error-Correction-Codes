I = uint8(imread('c.png'));
imageDim = size(I);
snr = 15;

subplot(2,2,[1 3]);
imshow(uint8(I(:,:,1)));

redBin = uint8(dec2bin(I(:,:,1)) - '0');
redBin = reshape(redBin, 1, []);

trellis = poly2trellis(7, [171, 133]);
codeOut = convenc(redBin, trellis);

codeOutNoise = int8(awgn(double(codeOut), snr));
codeOutNoise(find(codeOutNoise < 0)) = 0;
codeOutNoise(find(codeOutNoise > 1)) = 1;

redBinOut = vitdec(codeOutNoise, trellis, 5, 'trunc', 'hard');

redBinNoise = int8(awgn(double(redBin), snr));
redBinNoise(find(redBinNoise < 0)) = 0;
redBinNoise(find(redBinNoise > 1)) = 1;

redBinNoise = reshape(redBinNoise, imageDim(1), imageDim(2), []);
redBinNoiseImage = zeros(imageDim(1), imageDim(2));
for h = 1:imageDim(1)
    for w = 1:imageDim(2)
        redBinNoiseImage(h, w) = bin2dec(char(reshape(redBinNoise(h, w, :) + '0', 1, [])));
    end
end
subplot(2,2,2);
imshow(uint8(redBinNoiseImage));

redBinOut = reshape(redBinOut, imageDim(1), imageDim(2), []);
red = zeros(imageDim(1), imageDim(2));
for h = 1:imageDim(1)
    for w = 1:imageDim(2)
        red(h, w) = bin2dec(char(reshape(redBinOut(h, w, :) + '0', 1, [])));
    end
end

subplot(2,2,4);
imshow(uint8(red));

display(sum(abs(I - uint8(redBinNoiseImage)), 'all'));
display(sum(abs(I - uint8(red)), 'all'));