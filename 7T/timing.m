clc;clear;
workingpath='/Volumes/WD_D/gufei/7t/timing';
cd(workingpath)
run=3;
for i=1:run
    file=dir(['s1003_run' num2str(i) '*']);
%     condition=load(file.name,'con');
%     con=condition.con;
    load(file.name,'con');
    % compute times
    timefear=round(con(con(:,2)==1,1)-15)';
    timeneutral=round(con(con(:,2)==2,1)-15)';
    
    % run2
    file=dir(['s1003_run' num2str(7-i) '*']);
    load(file.name,'con');
    timefear(2,:)=round(con(con(:,2)==1,1)-15)';
    timeneutral(2,:)=round(con(con(:,2)==2,1)-15)';
    
    % write times to txt files
    dlmwrite(['run' num2str(i) '_fear.txt'],timefear,'delimiter',' ')
    dlmwrite(['run' num2str(i) '_neutral.txt'],timeneutral,'delimiter',' ')
end