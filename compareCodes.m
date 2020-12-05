image = uint8(imread('earth.png')); % Loads the image and stores its dimensions
imageDim = size(image);
bitstream = reshape(de2bi(image, 'left-msb'), 1, []);

snrArray = (1:1:17);
uncodedBER = zeros(1,length(snrArray));
convBER = zeros(1,length(snrArray));
rsBER = zeros(1,length(snrArray));
rsvBER = zeros(1,length(snrArray));

for snr = 14:17
    uncoded = addNoise(bitstream,snr);
    convolutional = convolutionalEncoder(bitstream,snr);
    reedSolomon = reedSolomonEncoder(bitstream,snr);
    reedSolomonViterbi = concatenatedRSV(bitstream,snr);
    
    uncodedBER(snr) = sum(abs(bitstream-uint8(uncoded))) / length(bitstream);
    convBER(snr) = sum(abs(bitstream-uint8(convolutional))) / length(bitstream);
    rsBER(snr) = sum(abs(bitstream-uint8(reedSolomon))) / length(bitstream);
    rsvBER(snr) = sum(abs(bitstream-uint8(reedSolomonViterbi))) / length(bitstream);
end

clf;
%lineseries = semilogy(snrArray, uncodedBER, 'o-');
hold on;
lineseries = semilogy(snrArray, convBER, 'o-');
hold on;
lineseries = semilogy(snrArray, rsBER, 'o-');
hold on;
lineseries = semilogy(snrArray, rsvBER, 'o-');
grid on;
legend('Uncoded', 'K=7 rate 1/2 Convolutional Code', 'Reed Solomon', 'Reed Solomon Viterbi');

