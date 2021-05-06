r=zeros(13,4);
maskNames={'Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'};
datadir='/Volumes/WD_E/gufei/7T_odor/S01/12blip/';
% whole Amy and 3 subregions
figure;
for i=1:length(maskNames)
    day1=load([datadir 'day1_' maskNames{i} '_beta.txt']);
    day2=load([datadir 'day2_' maskNames{i} '_beta.txt']);
    r(i,:)=diag(corr(day1(:,end-3:end),day2(:,end-3:end)));    
    subplot(length(maskNames),4,(i-1)*4+1)
    scatter(day1(:,end-3),day2(:,end-3))
    subplot(length(maskNames),4,(i-1)*4+2)
    scatter(day1(:,end-2),day2(:,end-2))
    subplot(length(maskNames),4,(i-1)*4+3)
    scatter(day1(:,end-1),day2(:,end-1))
    subplot(length(maskNames),4,(i-1)*4+4)
    scatter(day1(:,end-0),day2(:,end-0))
end
% 9 regions
day1=load([datadir 'day1_Amy_beta.txt']);
day2=load([datadir 'day2_Amy_beta.txt']);
roi=unique(day1(:,4));
figure;
for i=1:length(roi)
    r(i+4,:)=diag(corr(day1(day1(:,4)==roi(i),end-3:end),day2(day2(:,4)==roi(i),end-3:end)));
    subplot(length(roi),4,(i-1)*4+1)
    scatter(day1(day1(:,4)==roi(i),end-3),day2(day2(:,4)==roi(i),end-3))
    subplot(length(roi),4,(i-1)*4+2)
    scatter(day1(day1(:,4)==roi(i),end-2),day2(day2(:,4)==roi(i),end-2))
    subplot(length(roi),4,(i-1)*4+3)
    scatter(day1(day1(:,4)==roi(i),end-1),day2(day2(:,4)==roi(i),end-1))
    subplot(length(roi),4,(i-1)*4+4)
    scatter(day1(day1(:,4)==roi(i),end-0),day2(day2(:,4)==roi(i),end-0))
end


