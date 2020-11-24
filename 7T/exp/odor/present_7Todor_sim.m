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

%ÿ������matlabʱ��������Ӷ�����ͬ�ģ������������һ����
%����ͨ��ϵͳʱ�����������������
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end)) ;
rng(tseed);

%���6�Ե�˳��
pair=[1 2;1 3;1 5;2 3;2 5;3 5];
pair=pair+6;
pair=pair(randperm(6),:);

ett('set',ettport,0)
WaitSecs(2);

for i=1:6
    % ���������˳��
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
