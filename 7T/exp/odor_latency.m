% port
port='COM5';
% open ttl port
ttlport='COM6';
odor = 1;
% ettport
delete(instrfindall('Type','serial'));
ettport=ett('init',port);
WaitSecs(2);
s = serial(ttlport, 'BaudRate',115200);
fopen(s); 
for odor=1:5
% odor
ett('set',ettport,odor);
fwrite(s, 1);
WaitSecs(2);
ett('set',ettport,0);
fwrite(s, 0);
WaitSecs(11);
end