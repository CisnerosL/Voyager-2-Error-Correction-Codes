image = uint8(imread('earth.png')); % Loads the image and stores its dimensions
imageDim = size(image);
bitstream = reshape(de2bi(image, 'left-msb'), 1, []);
snr = 3;

noisyBitstream = simulateConcatenatedRSV(bitstream, snr);

noisyInts = bi2de(reshape(noisyBitstream, [], 8), 'left-msb');
noisyImage = uint8(reshape(noisyInts, imageDim(1), imageDim(2), []));

imshow(noisyImage);