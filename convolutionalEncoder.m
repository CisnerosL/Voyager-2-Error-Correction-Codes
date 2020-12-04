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

function decodedBitstream = convolutionalEncoder(bitstream, snr)
% Defines a trellis structure for our encoder implementation. See slide 2
% of this MIT lecture for a visual representation of this common trellis.
% https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-973-communication-system-design-spring-2006/lecture-notes/lecture_11.pdf
trellis = poly2trellis(7, [171, 133]);
encodedBitstream = convenc(bitstream, trellis);

% Adds noise to the encoded bitstream to simulate transmission
noisyEncodedBitstream = addNoise(encodedBitstream, snr);

% Decodes the bitstream with the Viterbi algorithm. Note: 5 = traceback
% depth. This is a generalized value for rate 1/2 codes.
decodedBitstream = vitdec(noisyEncodedBitstream, trellis, 5, 'trunc', 'hard');
end




