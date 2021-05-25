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

sil=imread([datadir filesep '非常不同.bmp']);
sir=imread([datadir filesep '非常相似.bmp']);
imwrite([sil number sir],[outdir filesep 'numbersi.bmp']);

int=zeros(2,5);
for i=1:5
% valence
temp=result(result(:,1)==i&result(:,2)==1,6);
temp(temp==0)=nan;
int(1,i)=nanmean(temp);
% intensity
temp=result(result(:,1)==i&result(:,2)==2,6);
temp(temp==0)=nan;
int(2,i)=nanmean(temp);
end