function fileSize = showFileSize(filename)
    % Check if the file exists
    if ~isfile(filename)
        error('File not found.');
    end

    % Get file information
    fileInfo = dir(filename);

    % Extract file size
    fileSize = fileInfo.bytes;

    % Display file size in bytes
    fprintf('Size of the file "%s" is %d bytes.\n', filename, fileSize);
end