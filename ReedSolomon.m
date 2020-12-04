% This is an implementation of an RS()

% Loads the image and stores its dimensions
image = uint8(imread('earth.png'));
imageDim = size(image);

% Sets the snr value (dB) for our simulated AWGN
snr = 11;

n = 255;
k = 223;
primitivePolynomial = 285; % 285 = 0b100011101 -> X^8 + X^4 + X^3 + X^2 + 1
m = 8;

intStream = reshape(image, [], 1);
bitstream = reshape(de2bi(image, 'left-msb'), 1, []);

% The encoder function requires 
numInts = imageDim(1) * imageDim(2) * imageDim(3);
numMsgs = (uint32(numInts / k));
paddedLength = k * numMsgs;

intStream(paddedLength) = 0;
messages = reshape(intStream, k, []);
decodedMessages = zeros(size(messages));

gp = rsgenpoly(n, k, primitivePolynomial);

rsEncoder = comm.RSEncoder(n, k, gp);
rsDecoder = comm.RSDecoder(n, k, gp);

for msg = 1:numMsgs
    encodedMessages(:, msg) = rsEncoder(messages(:, msg));
end

encodedBitstream = reshape(de2bi(reshape(encodedMessages, 1, []), 'left-msb'), 1, []);

noisyEncodedBitstream = int8(awgn(double(encodedBitstream), snr));
noisyEncodedBitstream(find(noisyEncodedBitstream < 0)) = 0;
noisyEncodedBitstream(find(noisyEncodedBitstream > 1)) = 1;

% Adds noise to the bitstream to simulate uncoded transmission on a noisy
% channel.
noisyBitstream = int8(awgn(double(bitstream), snr));
noisyBitstream(find(noisyBitstream < 0)) = 0;
noisyBitstream(find(noisyBitstream > 1)) = 1;

noisyEncodedMessages = reshape(bi2de(reshape(noisyEncodedBitstream, [], 8), 'left-msb'), n, []);

for msg = 1:numMsgs
    decodedMessages(:, msg) = rsDecoder(noisyEncodedMessages(:, msg));
end

decodedMessages = decodedMessages(1:numInts);
decodedImage = uint8(reshape(decodedMessages(), imageDim(1), imageDim(2), []));

noisyInts = bi2de(reshape(noisyBitstream, [], 8), 'left-msb');
noisyImage = uint8(reshape(noisyInts, imageDim(1), imageDim(2), []));

% plots the original image, the coded and 'transmitted' image, and the
% uncoded and 'transmitted' image.
subplot(2,2,[1 3]);
imshow(image);

subplot(2,2,2);
imshow(uint8(noisyImage));

subplot(2,2,4);
imshow(decodedImage);

decodedBitstream = reshape(de2bi(reshape(decodedMessages, 1, []), 'left-msb'), 1, []);
display(sum(abs(bitstream-uint8(noisyBitstream))) / length(bitstream));
display(sum(abs(bitstream-uint8(decodedBitstream))) / length(bitstream));
