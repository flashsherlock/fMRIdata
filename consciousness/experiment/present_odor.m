% set port
delete(instrfindall('Type','serial'));
s = serial('com3', 'BaudRate',115200);
% open port
fopen(s);  
% time
odort=5;
airt=15                                                                                                                                                  ;
% repeat

re=5;
odor=[2 4 5];
odorname={'ƒ˚√ ','«…øÀ¡¶','œ„À‚'};

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