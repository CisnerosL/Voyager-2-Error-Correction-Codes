image = uint8(imread('earth.png')); % Loads the image and stores its dimensions
imageDim = size(image);
snr = 10; % Sets the snr value (dB) for our simulated AWGN
itterations = 1;

bitstream = reshape(de2bi(image, 'left-msb'), 1, []);


for itt = 1:itterations
    %get the rs encoded bitstream
    reedSolomonBitstream = reedSolomonEncoder(bitstream,snr);

    % %Give the image some noise
    % noisyEncodedBitstream = addNoise(reedSolomonBitstream, snr);
    % noisyEncodedMessages = reshape(bi2de(reshape(noisyEncodedBitstream, [], 8), 'left-msb'), n, []);
    % 
    % %decode the messsage
    % for msg = 1:size(noisyEncodedMessages,2)
    %     decodedMessages(:, msg) = rsDecoder(noisyEncodedMessages(:, msg));
    % end
    % decodedMessages = decodedMessages(1:numInts);
    % decodedImage = uint8(reshape(decodedMessages(), imageDim(1), imageDim(2), []));
    % noisyInts = bi2de(reshape(noisyBitstream, [], 8), 'left-msb');
    % noisyImage = uint8(reshape(noisyInts, imageDim(1), imageDim(2), []));4

    decodedImage = uint8(reshape(reedSolomonBitstream, imageDim(1), imageDim(2), []));

    subplot(2,2,1);
    imshow(image);
    subplot(2,2,2);
    imshow(decodedImage);
end

