function noisyBitstream = addNoise(bitstream, snr)
    noisyBitstream = int8(awgn(double(bitstream), snr));
    noisyBitstream(find(noisyBitstream < 0)) = 0;
    noisyBitstream(find(noisyBitstream > 1)) = 1;
end