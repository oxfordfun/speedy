% callFileReadSpeed.m
file_base = 'STO_300K_35meV.sqw';
file_base2 = 'STO_300K_35meV_h4.sqw';
file_base3 = 'STO_400K_10.1meV.sqw'; %(66Gb);
data_path = '/instrument/MERLIN/RBNumber/RB2220429/sqw';

filename = fullfile(data_path,file_base2);
file_part = 0.002;
chunk_size = 9*1000;
[speed,time] = fileReadSpeed_horace(filename,file_part,chunk_size)


%parallelFileReadSpeed(filename, 10);  % 10 MB chunk size      
% Call the fileReadSpeed function
fileReadSpeed(filename);
% 
% filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_300K_35meV_h4.sqw'; 
% showFileSize(filename)
% % Call the fileReadSpeed function
% fileReadSpeed(filename);
% 
% % Define the file path
% filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_400K_10.1meV.sqw'; 
% showFileSize(filename)
% % Call the fileReadSpeed function
% fileReadSpeed(filename);




