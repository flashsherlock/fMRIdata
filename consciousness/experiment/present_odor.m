% set port
delete(instrfindall('Type','serial'));
s = serial('com6', 'BaudRate',115200);
% open port
fopen(s);  
% time
odort=5;
airt=15                                                                                                                                                  ;
% repeat

re=5;
odor=[2 4 5];
odorname={'ƒ˚√ ','«…øÀ¡¶','œ„À‚'};
% fwrite(s, 6); %air
% disp('air')
% WaitSecs(15); 

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
fclose(s);
% delete(instrfindall('Type','serial'));