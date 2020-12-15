% Noisy BPSK Transmission Simulation w/ K=7, Rate 1/2 Convolutional Error 
% Correcting Code
%
% By Matthew Luyten and Luis Cisneros
%
% This function simulates the transmission of a bitstream encoded with a
% K=7, rate 1/2 convolutional encoder at a defined SNR in dB..

function decodedBitstream = simulateConvolutionalCode(bitstream, snr)
    % Defines a trellis structure for our encoder implementation. See slide 2
    % of this MIT lecture for a visual representation of this common trellis.
    % https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-973-communication-system-design-spring-2006/lecture-notes/lecture_11.pdf
    trellis = poly2trellis(7, [171, 133]);
    encodedBitstream = convenc(bitstream, trellis);

    % Adds noise to the encoded bitstream to simulate transmission
    %noisyEncodedBitstream = addNoise(encodedBitstream, snr);
    noisyEncodedBitstream = simulateTransmission(encodedBitstream, snr);
    
    % Decodes the bitstream with the Viterbi algorithm. Note: 5 = traceback
    % depth. This is a generalized value for rate 1/2 codes.
    decodedBitstream = vitdec(noisyEncodedBitstream, trellis, 5, 'trunc', 'hard');
end




