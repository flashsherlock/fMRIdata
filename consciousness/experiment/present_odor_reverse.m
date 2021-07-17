% set port
delete(instrfindall('Type','serial'));
s = serial('com6', 'BaudRate',115200);
% open port
fopen(s);  
% time
odort=4;
airt=16                                                                                                                                                  ;
% repeat
re=1;
odor=[5 4 2];
odorname={'œ„À‚','«…øÀ¡¶','ƒ˚√ '};

% start marker
fwrite(s, 1);
WaitSecs(1);
% 15s air
fwrite(s, 6);
disp('air')
WaitSecs(15);
for i=1:re

    disp(i);
    for j=1:length(odor)  
    fwrite(s, odor(j)); %2
    disp(['run' num2str(i) '   ' odorname{j}])
    WaitSecs(odort); 
    fwrite(s, 6); 
    disp('air')
    WaitSecs(airt); 
    end

end
% stop marker
fwrite(s, 1);
WaitSecs(1);
fwrite(s, 6);
% close port
fclose(s);
% delete(instrfindall('Type','serial'));