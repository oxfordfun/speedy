function [read_speed, elapsedTime] = optimizedFileReadSpeed(filename, read_share, chunk_size)
    % Check if the file exists
    if ~isfile(filename)
        error('File not found');
    end

    fileInfo = dir(filename);
    fileSize = fileInfo.bytes / 4;  % Assuming 4 bytes per single precision float
    size_to_read = floor(fileSize * read_share);
    fprintf("Processing %d%% of %.2f GB file\n", read_share * 100, fileSize / (256 * 1024 * 1024));

    % Calculate number of chunks and adjust to fit the file size exactly
    n_chunks = floor((size_to_read * 4) / (chunk_size * 4));  % Adjust based on actual bytes to read

    % Pre-calculate random positions to read. Ensure they are within file size bounds
    positions = sort(randperm(fileSize - chunk_size, n_chunks));

    % Memory map the file
    m = memmapfile(filename, 'Format', 'single');

    % Start the timer
    tic;

    totalBytesRead = 0;
    for i = 1:n_chunks
        % Calculate position taking into account single precision float size
        position = positions(i);

        % Read chunk of data
        data = m.Data(position:(position + chunk_size - 1));
        totalBytesRead = totalBytesRead + numel(data) * 4;  % Update total bytes read
    end

    % Stop the timer
    elapsedTime = toc;

    % Calculate read speed
    read_speed = totalBytesRead / elapsedTime;  % bytes per second

    % Convert read speed to MB/s
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the result
    fprintf('Read %.2f MB in %.2f seconds: %.2f MB/s\n', totalBytesRead / (1024 * 1024), elapsedTime, read_speed_MBps);
end