function [data,error]=marker_trans_7T(data)
%transform markers
%run start 1, stimuli start -1
%orange cross 2
%odor onset 7,8,9,10,11
%odor offset -7,-8,-9,-10,-11
%error 
% bin to dec
data=pinlv(data);
%去掉连续的重复的marker
data(:,2)=quchong(data(:,2));
%统计各个marker的频数
t=tabulate(data(:,2));
%choose markers
% marker=[7,8,9,10,-7,-8,-9,-10,1,-1,2];
marker=[7,8,9,10,11,-7,-8,-9,-10,-11,1,-1,2];
t=t(ismember(t(:,1),marker),:);
%check number of each markers
% times=[8 8 8 8 1 1 32 8 8 8 8];
times=[6 6 6 6 6 1 1 30 6 6 6 6 6];
error=t((t(:,2)'==times)~=1,1)';
if isempty(error)
    error=0;
else
    disp('Error in marker!')
    disp(t(:,2)')
end
end

function temp = pinlv( matrix )
%进行marker的二进制转十进制
% for i=2:9
% tabulate(matrix(:,i));
% end
temp=matrix(:,2:5);

% % old code
% % temp(temp<4.99)=0;
% % temp(temp>=4.99)=5;
% temp=num2str(temp/5);
% temp(isspace(temp)) = [];
% temp=reshape(temp,[],4);
% %反转
% temp=temp(:,end:-1:1);
% %二进制转十进制
% temp=bin2dec(temp);

% convert to integer values
temp=ceil(temp/5);
% convert to digits
temp=temp*[1;2;4;8];
expect=[0 1 2 7 8 9 10 11];
% change unexpected values to previous one
while ~isempty(temp(ismember(temp,expect)==0))
    temp(ismember(temp,expect)==0)=temp(find(ismember(temp,expect)==0)-1);
end
% change distinct values to previous one
before=temp(1:end-2);
after=temp(3:end);
diff=find(((temp(2:end-1)-before)&(temp(2:end-1)-after))==1);
% avoid change 0 between 1 and 2
for di=1:length(diff)
    if ~(temp(diff(di))==1 && temp(diff(di)+2)==2)
        temp(diff(di)+1)=temp(diff(di));
    end
end
%tabulate(temp);
%把数据和转后的marker合并
temp=[matrix(:,1) temp];
%save('sub01','temp');
end

function temp = quchong( matrix )
%把连续的部分保留第一个
matrix1=zeros(length(matrix),1);
% matrix2=matrix1;
%错一位
matrix1(2:end)=matrix(1:end-1);
% matrix2(3:end)=matrix(1:end-2);
%原始的减去后错一位的
%首个标记保留，之后首个0会成为负值
temp=matrix-matrix1;
temp(temp==9)=11;
temp(temp==8)=10;
temp(temp==7)=9;
temp(temp==6)=8;
temp(temp==5)=7;
end

