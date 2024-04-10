xl=dir('20subj*.xlsx');
lable=cell(4,12);
data=zeros(20,48);
lablefix={'FP','FU','HP','HU'};
for i=1:length(xl)
data(:,4*i-3:4*i)=xlsread(xl(i).name,'results','K2:N21');
  for j=1:4
      if length(xl(i).name)<36
        c=xl(i).name(8:24);
      else
        c=xl(i).name(8:30);
      end
    c(c=='.')='_';
    lable{j,i}=[c '_' lablefix{j}];
  end
end
lable=reshape(lable,1,48);
output=[lable;num2cell(data)];
xlswrite('draw.xlsx', output, 'results', 'A1');