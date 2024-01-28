function read_speed = parallelFileReadSpeed(filename, chunkSizeMB)
    % Check if the file exists
    if ~isfile(filename)
        error('File not found');
    end

    % Get file information
    fileInfo = dir(filename);
    fileSize = fileInfo.bytes;

    % Convert chunk size from MB to bytes
    chunkSize = chunkSizeMB * 1024 * 1024;

    % Calculate the number of chunks
    numChunks = ceil(fileSize / chunkSize);

    % Start the parallel pool
    pool = gcp('nocreate'); % Get the current parallel pool
    if isempty(pool)
        pool = parpool(); % Create a new pool if none exists
    end

    % Start the timer
    tic;

    % Read the file in parallel
    parfor (i = 1:numChunks, pool.NumWorkers)
        startByte = (i - 1) * chunkSize + 1;
        endByte = min(i * chunkSize, fileSize);
        readChunk(filename, startByte, endByte);
    end

    % Stop the timer
    elapsedTime = toc;

    % Calculate reading speed
    read_speed = fileSize / elapsedTime; % bytes per second

    % Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the result
    fprintf('Read %d bytes in %f seconds: %f MB/s\n', fileSize, elapsedTime, read_speed_MBps);
end

function readChunk(filename, startByte, endByte)
    fileId = fopen(filename, 'rb');
    fseek(fileId, startByte-1, 'bof');
    fread(fileId, endByte - startByte + 1, 'uint8');
    fclose(fileId);
end