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
odor=[1 2 3 4 5];
odorname={'∫Ï‘Ê','ƒ˚√ ','≥»◊”','«…øÀ¡¶','œ„À‚'};
fwrite(s, 6); %air
disp('air')
WaitSecs(15); 

for i=1:re

    disp(i);
    for j=1:length(odor)  
    fwrite(s, odor(j)); %2
    disp(odorname{j})
    WaitSecs(odort); 
    fwrite(s, 6); 
    disp('air')
    WaitSecs(airt); 
    end

end
fclose(s);
% delete(instrfindall('Type','serial'));