function [data,error]=marker_trans(data)
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
t(7,:)=[];
% 判断marker数量是不是对的
times=[15 3 3 3 3 3 3 3 3 3 3 15];
error=t((t(:,2)'==times)~=1,1)';
if isempty(error)
    error=0;
else
    disp('Error in marker!')
end
%保存转换之后的
% save(['.\trans\' filename(i).name(1:end-4) '_trans.mat'],'data');

end

function [temp] = pinlv( matrix )
%进行marker的二进制转十进制
% for i=2:9
% tabulate(matrix(:,i));
% end
temp=matrix(:,2:7);
temp=num2str(temp/5);
temp(isspace(temp)) = [];
temp=reshape(temp,[],6);
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
%修改编号，气味为1-5，空气是6
matrix(matrix==4)=3;
matrix(matrix==8)=4;
matrix(matrix==16)=5;
matrix(matrix==32)=6;
%把连续的部分保留第一个
matrix1=zeros(length(matrix),1);
%错一位
matrix1(2:end)=matrix(1:end-1);
%原始的减去后错一位的
%首个标记保留，之后首个0会成为负值
temp=matrix-matrix1;
end

