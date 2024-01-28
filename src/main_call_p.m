% parallelFileReadSpeed.m

filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_300K_35meV.sqw'; 
showFileSize(filename)
% Call the fileReadSpeed function
parallelFileReadSpeed(filename, 10);  % 10 MB chunk size

filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_300K_35meV_h4.sqw'; 
showFileSize(filename)
% Call the fileReadSpeed function
parallelFileReadSpeed(filename, 10);  % 10 MB chunk size      

% Define the file path
filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_400K_10.1meV.sqw'; 
% Call the fileReadSpeed function
parallelFileReadSpeed(filename, 10);  % 10 MB chunk size

