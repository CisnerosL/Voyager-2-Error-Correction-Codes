% simulateTransmission
%
% By Matthew Luyten and Luis Cisneros
%
% This function simulates the transmission of a bitstream over a BPSK
% channel with additive white Gaussian noise (AWGN) at a user-defined SNR.

function outputBitstream = simulateTransmission(inputBitstream, snr)
    % Creates mod/demod functions
    modulator = comm.BPSKModulator;
    demodulator = comm.BPSKDemodulator;
    
    waveform = modulator(reshape(inputBitstream, [], 1)); % Modulates waveform
    noisyWaveform = awgn(waveform, snr, 'measured'); % Adds AWGN
    outputBitstream = reshape(demodulator(noisyWaveform), 1, []); % Demodulates waveform
end