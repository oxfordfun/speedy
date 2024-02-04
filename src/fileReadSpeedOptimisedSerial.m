function [read_speed, elapsedTime, n_chunks] = fileReadSpeedOptimisedSerial(filename, read_share, chunk_size_bytes)
    % Ensure the chunk size is in elements, not bytes, for type 'single'
    % default chunk size: 10 MB byte
    bytes_per_element = 4; % bytes in a single precision float
    chunk_size_elements = chunk_size_bytes / bytes_per_element;

    % Check if the file exists
    if ~isfile(filename)
        error('File not found');
    end

    % Get the total number of elements in the file
    fileInfo = dir(filename);
    total_elements = fileInfo.bytes / bytes_per_element;
    elements_to_read = floor(total_elements * read_share);

    fprintf("Processing %d%% of %.2f single\n",read_share*100,total_elements)

    % Open the file
    fileId = fopen(filename, 'r');
    if fileId == -1
        error('Error opening file');
    end

    % Calculate the number of chunks to read
    n_chunks = ceil(elements_to_read / chunk_size_elements);

    % Initialize variables for reading
    totalBytesRead = 0;
    tic; % Start timing

    for i = 1:n_chunks
        % Determine the size of the current chunk
        if i < n_chunks
            current_chunk_size = chunk_size_elements;
        else
            % Last chunk might be smaller
            current_chunk_size = elements_to_read - totalBytesRead / bytes_per_element;
        end

        % Read the chunk
        [data, elementsRead] = fread(fileId, current_chunk_size, 'single');
        totalBytesRead = totalBytesRead + elementsRead * bytes_per_element;
    end

    % Stop timing
    elapsedTime = toc;

    % Close the file
    fclose(fileId);

    % Calculate reading speed
    read_speed = totalBytesRead / elapsedTime; % bytes per second

    % Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the results
    fprintf('Read %d MB in %f seconds: %f MB/s, across %d chunks.\n', totalBytesRead / (1024 * 1024), elapsedTime, read_speed_MBps, n_chunks);
end
