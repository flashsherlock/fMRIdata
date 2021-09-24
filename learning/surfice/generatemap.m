[num,txt,raw]=xlsread('d.xlsx','A2:C10');
% eval(txt{1,3})
% command='3dcalc ';
c='abcdefghijk';
img=[];
exp=[];
for i=1:length(num)
    img=[img ' -' c(i) ' ' txt{i,1} '.hdr' ];
    exp=[exp 'step(' (c(i)) ')*' num2str(num(i)) '+'];
end
command=['3dcalc' img ' -expr ' '''' exp(1:end-1) '''' ' -prefix all.nii -float'];
unix(command)