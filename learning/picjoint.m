datadir='C:\gufei\github\fMRIdata\learning\PicturesFolder';
outdir='C:\gufei\github\fMRIdata\7T\exp\ins';
number=[];
for i=1:7
    number=[number imread([datadir filesep num2str(i) '.bmp'])];
end
imwrite(number,[outdir filesep 'number.bmp']);

val=imread([datadir filesep '�ǳ�����.bmp']);
var=imread([datadir filesep '�ǳ�����.bmp']);
imwrite([val number var],[outdir filesep 'number1.bmp']);

inl=imread([datadir filesep '�ǳ�΢��.bmp']);
inr=imread([datadir filesep '�ǳ�ǿ��.bmp']);
imwrite([inl number inr],[outdir filesep 'number2.bmp']);