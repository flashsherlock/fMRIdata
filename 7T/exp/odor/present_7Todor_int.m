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

%ÿ������matlabʱ��������Ӷ�����ͬ�ģ������������һ����
%����ͨ��ϵͳʱ�����������������
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end)) ;
rng(tseed);

%���6�Ե�˳��
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
