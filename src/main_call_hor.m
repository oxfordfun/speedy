% callFileReadSpeed.m
file_base = 'STO_300K_35meV.sqw'; %(178G)
file_base2 = 'STO_300K_35meV_h4.sqw'; %(91G)
file_base3 = 'STO_400K_10.1meV.sqw'; %(63Gb);
data_path = '/instrument/MERLIN/RBNumber/RB2220429/sqw';
%data_path = '/mnt/ceph/home/y1113254/Horace_test/sqw';

filename = fullfile(data_path,file_base);
%chunk_size = 10e6;
chunk_size = 1e4;% 9*4*100; This is typical chunk size for HORACE cut. 100 events
file_part = 0.0002;
[read_speed,elapsedTime] = fileReadSpeed_horace(filename,file_part,chunk_size/4)
[speed,time] = fileReadSpeedOptimisedRandom(filename,file_part, chunk_size)

file_part = 0.02;
%[speed,time] = fileReadSpeedOptimisedRandomP(filename,file_part, chunk_size)

file_part = 0.2;
%[speed,time] = fileReadSpeedOptimisedRandomP(filename,file_part, chunk_size)

file_part = 1;
%[speed,time] = fileReadSpeedOptimisedRandomP(filename,file_part, chunk_size)