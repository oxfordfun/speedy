function [read_speed, elapsedTime, n_chunks] = fileReadSpeedOptimisedRandom(filename, read_share, chunk_size_bytes)

% Set default chunk size to 10 MB if not specified
    if nargin < 3
        chunk_size_bytes = 10e6; % 10 MB in bytes
    end

    % Check if the file exists
    if ~isfile(filename)
        error('File not found');
    end

    % Get file size in bytes
    fileInfo = dir(filename);
    total_bytes = fileInfo.bytes;
    bytes_to_read = floor(total_bytes * read_share);

    % Determine the number of chunks
    n_chunks = ceil(bytes_to_read / chunk_size_bytes);
    
    % Open the file
    fileId = fopen(filename, 'r');
    if fileId == -1
        error('Error opening file');
    end

    % Calculate max start byte for random starts
    max_start_byte = max(1, total_bytes - chunk_size_bytes);
    
    % Manually calculate random start positions for each chunk
    start_positions_bytes = 1 + floor(rand(1, n_chunks) * (max_start_byte - 1));
    start_positions_bytes = sort(start_positions_bytes);    

    ic = 0;
    totalBytesRead = 0;
    tic; % Start timing

    for i = 1:n_chunks
        % Seek to the start position
        fseek(fileId, start_positions_bytes(i), 'bof');
        
        % Determine actual bytes to read, adjusting for file end
        actual_chunk_size = min(chunk_size_bytes, total_bytes - start_positions_bytes(i));
        
        % Read the chunk and count bytes
        [data, elementsRead] = fread(fileId, actual_chunk_size, 'uint8');
        totalBytesRead = totalBytesRead + numel(data);
        ic = ic+1;
        if ic>100
            fprintf('step %d#%d\n',i,n_chunks);
            ic = 0;
        end
        
    end

    elapsedTime = toc; % Stop timing
    fclose(fileId); % Close the file

    % Calculate reading speed
    read_speed = totalBytesRead / elapsedTime; % bytes per second

    % Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the results
    fprintf('Read %d MB in %f seconds: %f MB/s, across %d chunks (random access).\n', totalBytesRead / (1024 * 1024), elapsedTime, read_speed_MBps, n_chunks);
end
