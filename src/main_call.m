% callFileReadSpeed.m

filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_300K_35meV.sqw';
% Call the fileReadSpeed function
fileReadSpeed(filename);

filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_300K_35meV_h4.sqw'; 
showFileSize(filename)
% Call the fileReadSpeed function
fileReadSpeed(filename);

% Define the file path
filename = '/mnt/ceph/home/y1113254/Horace_test/sqw/STO_400K_10.1meV.sqw'; 
showFileSize(filename)
% Call the fileReadSpeed function
fileReadSpeed(filename);




