% Convolutional Encoder/Decoder (K=7, Rate 1/2) Image Test w/ AWGN
%
% By Matthew Luyten and Luis Cisneros
%
% This is an implementation of the K=7, rate 1/2 convolutional encode/decode
% schema used on the Voyager mission to Saturn. This implementation was
% also used as the inner code on the extended Voyager mission.
%
% This script loads in a sample image that mimics the images collected on
% the Voyager probes. The voyager camera collected 800x800 3-color images
% with 8-bit values representing each color level of each pixel.
% This image data is encoded with the convolutional encoder, corrupted with
% additive Gaussian white noise (AWGN), decodes it, and displays the
% 'transmitted' image. To demonstrate this implementatation vs an uncoded
% implementation, a copy of the image is corrupted with AWGN and displayed.

function convolvedBitstream = convolutionalEncoder(bitstream,snr)
% Loads the image and stores its dimensions
%image = uint8(imread('earth.png'));
%imageDim = size(image);

% Sets the snr value (dB) for our simulated AWGN
%snr = 15;

% Turns our image matrix of 8-bit rgb values to a single stream of bits
%bitstream = reshape(de2bi(image, 'left-msb'), 1, []);

% Defines a trellis structure for our encoder implementation. See slide 2
% of this MIT lecture for a visual representation of this common trellis.
% https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-973-communication-system-design-spring-2006/lecture-notes/lecture_11.pdf
trellis = poly2trellis(7, [171, 133]);
encodedBitstream = convenc(bitstream, trellis);

% Adds noise to the bitstream to simulate uncoded transmission on a noisy
% channel.
%noisyBitstream = int8(awgn(double(bitstream), snr));
noisyBitstream(find(noisyBitstream < 0)) = 0;
noisyBitstream(find(noisyBitstream > 1)) = 1;

% Adds noise to the encoded bitstream to simulate transmission
%noisyEncodedBitstream = int8(awgn(double(encodedBitstream), snr));
%noisyEncodedBitstream(find(noisyEncodedBitstream < 0)) = 0;
%noisyEncodedBitstream(find(noisyEncodedBitstream > 1)) = 1;
noisyEncodedBitstream = addNoise(bitstream, snr);

% Decodes the bitstream with the Viterbi algorithm. Note: 5 = traceback
% depth. This is a generalized value for rate 1/2 codes.
noisyDecodedBitstream = vitdec(noisyEncodedBitstream, trellis, 5, 'trunc', 'hard');

% Reshapes the decoded noisy bitstream into an HxWx3 matrix of uint8 RGB
% values.
noisyDecodedInts = bi2de(reshape(noisyDecodedBitstream, [], 8), 'left-msb');
noisyDecodedImage = uint8(reshape(noisyDecodedInts, imageDim(1), imageDim(2), []));

% Reshapes the uncoded noisy bitstream into an HxWx3 matrix of uint8 RGB
% values.
noisyInts = bi2de(reshape(noisyBitstream, [], 8), 'left-msb');
noisyImage = uint8(reshape(noisyInts, imageDim(1), imageDim(2), []));

% plots the original image, the coded and 'transmitted' image, and the
% uncoded and 'transmitted' image.
subplot(2,2,[1 3]);
imshow(image);

subplot(2,2,2);
imshow(uint8(noisyImage));

subplot(2,2,4);
imshow(noisyDecodedImage);
end




