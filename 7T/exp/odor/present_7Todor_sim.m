clear;
delete(instrfindall('Type','serial'));

port='COM4';
% if ~exist('ettport','var')
    ettport=ett('init',port);
% else
%     ett('open',ettport);
% end
odort=2;
airt=5;
interval=15;

%每次重启matlab时的随机种子都是相同的，所以随机数是一样的
%所以通过系统时间设置随机数的种子
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end)) ;
rng(tseed);

%随机6对的顺序
pair=[1 2;1 3;1 5;2 3;2 5;3 5];
pair=pair+6;
pair=pair(randperm(6),:);

ett('set',ettport,0)
WaitSecs(2);

for i=1:6
    % 随机两个的顺序
    pair(i,:)=pair(i,randperm(2));
    
    disp(pair(i,:));
    
    disp(pair(i,1))
    ett('set',ettport,pair(i,1))
    WaitSecs(odort); 
    disp('air')
    ett('set',ettport,0)
    WaitSecs(airt);     
        
    disp(pair(i,2))
    ett('set',ettport,pair(i,2))
    WaitSecs(odort); 
    disp('air')
    ett('set',ettport,0)
%     WaitSecs(airt); 
    
    WaitSecs(interval); 
end
disp('end');
