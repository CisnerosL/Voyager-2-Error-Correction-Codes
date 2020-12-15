% This is a test script that transmits an image over a noisy BPSK channel
% with both the V2 RSV ECC schema and no error correction. The script
% displays the original, uncoded, and V2 RSV coded images.

image = uint8(imread('./testImages/earth.png')); % Loads the image and stores its dimensions
imageDim = size(image);
bitstream = reshape(de2bi(image, 'left-msb'), 1, []);
snr = 3;

decodedBitstream = simulateConcatenatedRSV(bitstream, snr);
noisyBitstream = simulateTransmission(bitstream, snr);

decodedInts = bi2de(reshape(decodedBitstream, [], 8), 'left-msb');
decodedImage = uint8(reshape(decodedInts, imageDim(1), imageDim(2), []));
noisyInts = bi2de(reshape(noisyBitstream, [], 8), 'left-msb');
noisyImage = uint8(reshape(noisyInts, imageDim(1), imageDim(2), []));

subplot(2,2,[1 3]);
imshow(image);

subplot(2,2,2);
imshow(uint8(noisyImage));

subplot(2,2,4);
imshow(decodedImage);