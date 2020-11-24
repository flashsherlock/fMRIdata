clear;
delete(instrfindall('Type','serial'));

port='COM5';
% if ~exist('ettport','var')
    ettport=ett('init',port);
% else
%     ett('open',ettport);
% end
odort=2;
airt=20;

%每次重启matlab时的随机种子都是相同的，所以随机数是一样的
%所以通过系统时间设置随机数的种子
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end)) ;
rng(tseed);

%随机6对的顺序
pair=[1 2 3 4];
pair=pair+6;
pair=pair(randperm(4));

ett('set',ettport,0)
WaitSecs(2);

for i=1:4
    disp(pair(i))
    ett('set',ettport,pair(i))
    WaitSecs(odort); 
    disp('air')
    ett('set',ettport,0)
    WaitSecs(airt); 
end
disp('end');
