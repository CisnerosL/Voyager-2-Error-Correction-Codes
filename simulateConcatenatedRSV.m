function decodedBitstream = simulateConcatenatedRSV(bitstream, snr)
    % Turns the bitstream into an array of 8bit integers
    intStream = bi2de(reshape(bitstream, [], 8), 'left-msb');
    
    % These are the system specifications defined by the JPL technical
    % documents
    n = 255;
    k = 223;
    primitivePolynomial = 285; % 285 = 0b100011101 -> X^8 + X^4 + X^3 + X^2 + 1
    m = 8;
    
    % Padds the end of the int stream with 0's so that it can be divided
    % into equal, k length messages
    numInts = length(intStream);
    numMsgs = (uint32(numInts / k));
    paddedLength = k * numMsgs;

    % Turns the intstream into an array of k length messages
    intStream(paddedLength) = 0;
    messages = reshape(intStream, k, []);
    % Preallocates a decodedMessages array
    decodedMessages = zeros(size(messages));
    
    % Creates RS encoder and decoder structures
    gp = rsgenpoly(n, k, primitivePolynomial);
    rsEncoder = comm.RSEncoder(n, k, gp);
    rsDecoder = comm.RSDecoder(n, k, gp);

    % Encodes the messages
    for msg = 1:numMsgs
        encodedMessages(:, msg) = rsEncoder(messages(:, msg));
    end

    % Turns the encoded message array into a stream of bits
    RSencodedBitstream = reshape(de2bi(reshape(encodedMessages, 1, []), 'left-msb'), 1, []);
    
    % Encodes, adds noise, and decodes the bitstream with the convolutional
    % encoder
    noisyRSencodedBitstream = simulateConvolutionalCode(RSencodedBitstream, snr);
    
    % Turns the birstream into an int stream
    noisyEncodedMessages = reshape(bi2de(reshape(noisyRSencodedBitstream, [], 8), 'left-msb'), n, []);
    
    % Decodes the messages
    for msg = 1:numMsgs
        decodedMessages(:, msg) = rsDecoder(noisyEncodedMessages(:, msg));
    end
    
    decodedMessages = decodedMessages(1:numInts);
    decodedBitstream = reshape(de2bi(decodedMessages, 'left-msb'), 1, []);
    
end