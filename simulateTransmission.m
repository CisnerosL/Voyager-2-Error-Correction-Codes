function outputBitstream = simulateTransmission(inputBitstream, snr)
    modulator = comm.BPSKModulator;
    demodulator = comm.BPSKDemodulator;
    
    waveform = modulator(reshape(inputBitstream, [], 1));
    noisyWaveform = awgn(waveform, snr, 'measured');
    outputBitstream = reshape(demodulator(noisyWaveform), 1, []); 
end