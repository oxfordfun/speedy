function [read_speed,elapsedTime] = fileReadSpeed_horace(filename,read_share,chunk_size)
    % Check if the file existss
    if ~isfile(filename)
        error('File not found');
    end

    fileInfo = dir(filename);
    fileSize = fileInfo.bytes/4;
    size_to_read = floor(fileSize*read_share);
    fprintf("Processing %d%% of %.2f GB file\n",read_share*100,fileSize/(256*1024*1024))

%     % Open the file
%     fileId = fopen(filename, 'r');
%     if fileId == -1
%         error('Error opening file');
%     end
%     fseek(fileId,0,"eof");
%     size = ftell(fileId)/4;
% 
%     fseek(fileId,0,"bof");    
%     fclose(fileId);    

    % Initialize variables
    totalBytesRead = 0;
    n_chunks = floor(size_to_read/chunk_size)+1;

    acc = memmapfile(filename,'Format','single');
    pos = floor(rand(1,n_chunks)*(fileSize-2*chunk_size));
    pos = sort(pos);
    if max(pos)+chunk_size>fileSize
        error('requested position is outside of the file ranges')
    end
    % Start the timer
    tic;
    ic = 0;
    % Read the file in blocks
    for i=1:n_chunks
        %fseek(fileId,pos(i),"bof");
        data = acc.Data(pos(i):pos(i)+chunk_size);
        %[dataRead, bytesRead] = fread(fileId, chunk_size, 'uint8');
        totalBytesRead = totalBytesRead + numel(data)*4;
        ic = ic+1;
        if ic>100
            fprintf('step %d#%d\n',i,n_chunks);
            ic = 0;
        end
    end

    % Stop the timer
    elapsedTime = toc;

    % Close the file


    % Calculate reading speed
    read_speed = totalBytesRead / elapsedTime; % bytes per second

    % Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024);

    % Display the result
    fprintf('Read %d MB in %f seconds: %f MB/s\n', totalBytesRead/(1024*1024), elapsedTime, read_speed_MBps);
end