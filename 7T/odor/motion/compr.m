r=zeros(13,4);
maskNames={'Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'};
datadir='/Volumes/WD_E/gufei/7T_odor/S01/12blip/';
b='';
% b='_noblur';
run='';
% run='5run';

% whole Amy and 3 subregions
figure;
for i=1:length(maskNames)
    day1=load([datadir 'day1_' maskNames{i} ['_beta' b '.txt']]);
    day2=load([datadir 'day2_' maskNames{i} ['_' run 'beta' b '.txt']]);
    r(i,:)=diag(corr(day1(:,end-3:end),day2(:,end-3:end)));    
    for p=1:4
        subplot(length(maskNames),4,(i-1)*4+p)
        scatter(day1(:,end-4+p),day2(:,end-4+p))
        title(r(i,p))
        axis('square')
    end
end
% Piriform
day1=load([datadir 'day1_Pir' ['_beta' b '.txt']]);
day2=load([datadir 'day2_Pir' ['_' run 'beta' b '.txt']]);
roi={[21 22 29],[21 22],[21 29],21,22};
figure;
for i=1:length(roi)    
    r(i+4,:)=diag(corr(day1(ismember(day1(:,4),roi{i}),end-3:end),day2(ismember(day2(:,4),roi{i}),end-3:end)));    
    for p=1:4
        subplot(length(roi),4,(i-1)*4+p)
        scatter(day1(:,end-4+p),day2(:,end-4+p))
        title(r(i+4,p))
        axis('square')
    end
end
% 9 regions
% day1=load([datadir 'day1_Amy_beta_noblur.txt']);
% day2=load([datadir 'day2_Amy_5runbeta_noblur.txt']);
% roi=unique(day1(:,4));
% figure;
% for i=1:length(roi)
%     r(i+4,:)=diag(corr(day1(day1(:,4)==roi(i),end-3:end),day2(day2(:,4)==roi(i),end-3:end)));
%     subplot(length(roi),4,(i-1)*4+1)
%     scatter(day1(day1(:,4)==roi(i),end-3),day2(day2(:,4)==roi(i),end-3))
%     subplot(length(roi),4,(i-1)*4+2)
%     scatter(day1(day1(:,4)==roi(i),end-2),day2(day2(:,4)==roi(i),end-2))
%     subplot(length(roi),4,(i-1)*4+3)
%     scatter(day1(day1(:,4)==roi(i),end-1),day2(day2(:,4)==roi(i),end-1))
%     subplot(length(roi),4,(i-1)*4+4)
%     scatter(day1(day1(:,4)==roi(i),end-0),day2(day2(:,4)==roi(i),end-0))
% end


