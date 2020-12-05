function reedSolomonBitstream = reedSolomonEncoder(bitstream,snr)
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

    intStream(paddedLength) = 0;
    messages = reshape(intStream, k, []);
    decodedMessages = zeros(size(messages));

    gp = rsgenpoly(n, k, primitivePolynomial);

    rsEncoder = comm.RSEncoder(n, k, gp);
    rsDecoder = comm.RSDecoder(n, k, gp);

    encodedMessages = zeros(255,8610);%if something fails here remove this line

    for msg = 1:numMsgs
        encodedMessages(:, msg) = rsEncoder(messages(:, msg));
    end

    encodedBitstream = reshape(de2bi(reshape(encodedMessages, 1, []), 'left-msb'), 1, []);

    noisyEncodedBitstream = addNoise(encodedBitstream, snr);

    noisyEncodedMessages = reshape(bi2de(reshape(noisyEncodedBitstream, [], 8), 'left-msb'), n, []);

    for msg = 1:numMsgs
        decodedMessages(:, msg) = rsDecoder(noisyEncodedMessages(:, msg));
    end

    decodedMessages = decodedMessages(1:numInts);
    reedSolomonBitstream = reshape(de2bi(reshape(decodedMessages, 1, []), 'left-msb'), 1, []);
    %display(sum(abs(bitstream-uint8(noisyBitstream))) / length(bitstream));
    %display(sum(abs(bitstream-uint8(decodedBitstream))) / length(bitstream));

end
