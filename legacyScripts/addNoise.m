% addNoise
%
% By Matthew Luyten and Luis Cisneros
%
% This is a naiive implementation of a transmission simulation. It was
% replaced by the simulateTransmission function which simulates the
% transmission of a bitstream on a noisy BPSK channel.

function noisyBitstream = addNoise(bitstream, snr)
    noisyBitstream = int8(awgn(double(bitstream), snr, 'measured'));
    noisyBitstream(find(noisyBitstream < 0)) = 0;
    noisyBitstream(find(noisyBitstream > 1)) = 1;
end