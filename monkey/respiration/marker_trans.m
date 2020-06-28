function [data,error]=marker_trans(data)
%transform markers
%odor onset 1,2,3,4,5;air onset 6
%odor offset -1,-2,-3,-4,-5;air offset -6
%error 
% bin to dec
data=pinlv(data);
%ȥ���������ظ���marker
data(:,2)=quchong(data(:,2));
%ͳ�Ƹ���marker��Ƶ��
t=tabulate(data(:,2));
%ȥ����marker����һ��
t(7,:)=[];
% �ж�marker�����ǲ��ǶԵ�
times=[15 3 3 3 3 3 3 3 3 3 3 15];
error=t((t(:,2)'==times)~=1,1)';
if isempty(error)
    error=0;
else
    disp('Error in marker!')
end
%����ת��֮���
% save(['.\trans\' filename(i).name(1:end-4) '_trans.mat'],'data');

end

function [temp] = pinlv( matrix )
%����marker�Ķ�����תʮ����
% for i=2:9
% tabulate(matrix(:,i));
% end
temp=matrix(:,2:7);
temp=num2str(temp/5);
temp(isspace(temp)) = [];
temp=reshape(temp,[],6);
%��ת
temp=temp(:,end:-1:1);
%������תʮ����
temp=bin2dec(temp);
%tabulate(temp);
%�����ݺ�ת���marker�ϲ�
temp=[matrix(:,1) temp];
%save('sub01','temp');
end

function temp = quchong( matrix )
%�޸ı�ţ���ζΪ1-5��������6
matrix(matrix==4)=3;
matrix(matrix==8)=4;
matrix(matrix==16)=5;
matrix(matrix==32)=6;
%�������Ĳ��ֱ�����һ��
matrix1=zeros(length(matrix),1);
%��һλ
matrix1(2:end)=matrix(1:end-1);
%ԭʼ�ļ�ȥ���һλ��
%�׸���Ǳ�����֮���׸�0���Ϊ��ֵ
temp=matrix-matrix1;
end

