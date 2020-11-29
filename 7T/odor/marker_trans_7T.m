function [data,error]=marker_trans_7T(data)
%transform markers
%odor onset 1,2,3,4,5;air onset 6
%odor offset -1,-2,-3,-4,-5;air offset -6
%error 
% bin to dec
data=pinlv(data);
%去掉连续的重复的marker
data(:,2)=quchong(data(:,2));
%统计各个marker的频数
t=tabulate(data(:,2));
%去掉无marker的那一行
t(6,:)=[];
% 判断marker数量是不是对的
times=[8 8 8 8 1 1 32 8 8 8 8 ];
error=t((t(:,2)'==times)~=1,1)';
if isempty(error)
    error=0;
else
    disp('Error in marker!')
end
end

function temp = pinlv( matrix )
%进行marker的二进制转十进制
% for i=2:9
% tabulate(matrix(:,i));
% end
temp=matrix(:,2:5);
% temp(temp<4.99)=0;
% temp(temp>=4.99)=5;
temp=num2str(temp/5);
temp(isspace(temp)) = [];
temp=reshape(temp,[],4);
%反转
temp=temp(:,end:-1:1);
%二进制转十进制
temp=bin2dec(temp);
%tabulate(temp);
%把数据和转后的marker合并
temp=[matrix(:,1) temp];
%save('sub01','temp');
end

function temp = quchong( matrix )
%把连续的部分保留第一个
matrix1=zeros(length(matrix),1);
%错一位
matrix1(2:end)=matrix(1:end-1);
%原始的减去后错一位的
%首个标记保留，之后首个0会成为负值
temp=matrix-matrix1;
temp(temp==8)=10;
temp(temp==7)=9;
temp(temp==6)=8;
temp(temp==5)=7;
end

