% set port
delete(instrfindall('Type','serial'));
s = serial('com6', 'BaudRate',115200);
% open port
fopen(s);  
%air
fwrite(s, 6);
disp('air')
