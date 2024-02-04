function [read_speed, elapsedTime, n_chunks] = fileReadSpeedOptimisedRandomP(filename, read_share, chunk_size_bytes)
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

    % Calculate max start byte for random starts
    max_start_byte = max(1, total_bytes - chunk_size_bytes);
    
    % Manually calculate random start positions for each chunk
    start_positions_bytes = 1 + floor(rand(1, n_chunks) * (max_start_byte - 1));

    % Preallocate bytesRead array for parallel access
    bytesReadArray = zeros(1, n_chunks);

    % Ensure a parallel pool of the desired size is open
    % This step is optional and depends on how you manage your parallel pools
    pool = gcp('nocreate'); % Get current pool
    if isempty(pool)
        parpool('local', min(30, n_chunks)); % Modify 'local' if using a cluster
    end

    tic; % Start timing

    % Use parfor loop for parallel reading
    parfor i = 1:n_chunks
        % Open the file independently in each worker
        fileId = fopen(filename, 'r');
        if fileId == -1
            error(['Error opening file in worker: ', num2str(labindex)]);
        end
        
        % Seek to the start position
        fseek(fileId, start_positions_bytes(i), 'bof');
        
        % Determine actual bytes to read, adjusting for file end
        actual_chunk_size = min(chunk_size_bytes, total_bytes - start_positions_bytes(i));
        
        % Read the chunk and count bytes
        [data, elementsRead] = fread(fileId, actual_chunk_size, 'uint8');
        bytesReadArray(i) = numel(data);

        % Close the file in the worker
        fclose(fileId);
    end

    elapsedTime = toc; % Stop timing

    % Calculate total bytes read and reading speed
    totalBytesRead = sum(bytesReadArray);
    read_speed = totalBytesRead / elapsedTime; % bytes per second

    % Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the results
    fprintf('Read %d MB in %f seconds: %f MB/s, across %d chunks (random access, parallel).\n', totalBytesRead / (1024 * 1024), elapsedTime, read_speed_MBps, n_chunks);
end
