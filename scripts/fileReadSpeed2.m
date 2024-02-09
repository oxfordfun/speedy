function [read_speed, elapsedTime] = optimizedFileReadSpeed(filename, read_share, chunk_size)
    % Check if the file exists
    if ~isfile(filename)
        error('File not found');
    end

    fileInfo = dir(filename);
    fileSizeBytes = fileInfo.bytes; % Get file size in bytes
    fileSize = fileSizeBytes / 4; % Assuming single precision floats (4 bytes each)
    size_to_read = floor(fileSize * read_share); % Calculate size to read based on share
    fprintf("Processing %d%% of %.2f GB file\n", read_share * 100, fileSizeBytes / (1024^3));

    % Calculate number of chunks to read
    n_chunks = floor(size_to_read / chunk_size);
    
    % Generate random start positions for each chunk
    maxPosition = fileSize - chunk_size; % Maximum position for the start of a chunk
    positions = randi([1, max(maxPosition,1)], 1, n_chunks); % Ensure maxPosition is at least 1

    % Memory map the file
    m = memmapfile(filename, 'Format', 'single');

    % Start the timer
    tic;

    totalBytesRead = 0;
    for i = 1:numel(positions)
        position = positions(i);
        % Ensure the read does not go beyond the file size
        endPosition = min(position + chunk_size - 1, fileSize);
        data = m.Data(position:endPosition);
        totalBytesRead = totalBytesRead + numel(data) * 4; % Update total bytes read
    end

    % Stop the timer
    elapsedTime = toc;

    % Calculate read speed
    read_speed = totalBytesRead / elapsedTime; % bytes per second

    % Convert read speed to MB/s
    read_speed_MBps = read_speed / (1024^2);

    % Display the result
    fprintf('Read %.2f MB in %.2f seconds: %.2f MB/s\n', totalBytesRead / (1024^2), elapsedTime, read_speed_MBps);
end
