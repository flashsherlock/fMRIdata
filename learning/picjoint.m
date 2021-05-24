datadir='C:\gufei\github\fMRIdata\learning\PicturesFolder';
outdir='C:\gufei\github\fMRIdata\7T\exp\ins';
number=[];
for i=1:7
    number=[number imread([datadir filesep num2str(i) '.bmp'])];
end
imwrite(number,[outdir filesep 'number.bmp']);

val=imread([datadir filesep '非常难闻.bmp']);
var=imread([datadir filesep '非常好闻.bmp']);
imwrite([val number var],[outdir filesep 'number1.bmp']);

inl=imread([datadir filesep '非常微弱.bmp']);
inr=imread([datadir filesep '非常强烈.bmp']);
imwrite([inl number inr],[outdir filesep 'number2.bmp']);