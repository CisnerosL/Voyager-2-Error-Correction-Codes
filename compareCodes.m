% BER Cuve Generation w/ Noisy BPSK Transmission Simulation
%
% By Matthew Luyten and Luis Cisneros
%
% This code simulates the transmission of about 300 million bits over a
% BPSK channel over a range of SNR values in dB. All three of the ECC's are
% simulated in this fashion, as well as an uncoded control. The quantity of
% bit errors for each implementation at each SNR value is tracked and used
% to create BER curves for each ECC schema as well as the uncoded control.

images = {'./testImages/windows.png'}; % Defines desired image files for transmission
totalBits = 0;
numPasses = 6;
snrArray = (1:0.5:10); % Defines the various SNR values to be tested

% Preallocates arrays to keep track of the number of errors at each SNR
% value
uncodedErrors = zeros(1,length(snrArray));
convErrors = zeros(1,length(snrArray));
rsErrors = zeros(1,length(snrArray));
rsvErrors = zeros(1,length(snrArray));

for i = 1:numPasses % Transmits image 6 times to increase # of transmitted bits
    for im = images
        % Loads the image and stores its dimensions
        image = uint8(imread(string(im)));
        imageDim = size(image);
        bitstream = reshape(de2bi(image, 'left-msb'), 1, []);
        
        % Simulates transmission w/ each schema over an array of SNR values
        for index = 1:length(snrArray)
            uncoded = simulateTransmission(bitstream,snrArray(index));
            convolutional = simulateConvolutionalCode(bitstream,snrArray(index));
            reedSolomon = simulateReedSolomon(bitstream,snrArray(index));
            reedSolomonViterbi = simulateConcatenatedRSV(bitstream,snrArray(index));
            
            % Calculates the number of inverted bits after transmission
            uncodedErrors(index) = uncodedErrors(index) + sum(abs(bitstream-uint8(uncoded)));
            convErrors(index) = convErrors(index) + sum(abs(bitstream-uint8(convolutional)));
            rsErrors(index) = rsErrors(index) + sum(abs(bitstream-uint8(reedSolomon)));
            rsvErrors(index) = rsvErrors(index) + sum(abs(bitstream-uint8(reedSolomonViterbi)));
            
            % Alerts the User of the last simulation's SNR and the number
            % of passes completed
            msg = strjoin(['Pass', string(i), 'of', string(numPasses), '- SNR:', string(snrArray(index))]);
            disp(msg);
        end
        totalBits = totalBits + length(bitstream); % Keeps track of the total number of bits transmitted.
    end
end

% Calculates the various BER values for each implementation
uncodedBER = uncodedErrors/totalBits;
convBER = convErrors/totalBits;
rsBER = rsErrors/totalBits;
rsvBER = rsvErrors/totalBits;

% Displays plots the BER curves
clf;
lineseries = semilogy(snrArray, uncodedBER, 'o-');
hold on;
lineseries = semilogy(snrArray, convBER, 'o-');
hold on;
lineseries = semilogy(snrArray, rsBER, 'o-');
hold on;
lineseries = semilogy(snrArray, rsvBER, 'o-');
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Curves');
legend('Uncoded', 'K=7, Rate 1/2 Convolutional Code', 'RS(255, 223) Code', 'V2 RSV Code');

