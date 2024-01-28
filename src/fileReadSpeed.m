function read_speed = fileReadSpeed(filename)
    % Check if the file exists
    if ~isfile(filename)
        error('File not found');
    end

    % Open the file
    fileId = fopen(filename, 'r');
    if fileId == -1
        error('Error opening file');
    end

    % Initialize variables
    totalBytesRead = 0;
    blockSize = 1024 * 1024; % 1 MB block size
    buffer = zeros([1, blockSize], 'uint8'); % preallocate buffer

    % Start the timer
    tic;

    % Read the file in blocks
    while ~feof(fileId)
        [dataRead, bytesRead] = fread(fileId, blockSize, 'uint8');
        totalBytesRead = totalBytesRead + bytesRead;
        if bytesRead < blockSize
            break;
        end
    end

    % Stop the timer
    elapsedTime = toc;

    % Close the file
    fclose(fileId);

    % Calculate reading speed
    read_speed = totalBytesRead / elapsedTime; % bytes per second

    % Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the result
    fprintf('Read %d bytes in %f seconds: %f MB/s\n', totalBytesRead, elapsedTime, read_speed_MBps);
end