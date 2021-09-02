% load data
datadir='/Volumes/WD_D/gufei/consciousness/respdata/';
load([datadir 's06_0719.mat']);
adisr=1000;
adires=reshape(data,[],2);
acqsr=500;
acqres=load_acq([datadir 's06_0719.acq']);
acqres=acqres.data;
% resample
adires=resample(adires,acqsr,adisr);
% change acq markers
acqmarker=acqres(:,2:4)>0;
acqmarker=acqmarker*[1;2;4];
acqres=[acqres(:,1) acqmarker];
% plot
plot(adires)
figure
plot(acqres)
% choose data
% anesthetic
acq_ana=acqres(1131000:1289000,:);
adi_ana=adires(1145000:1303000,:);
% awake
acq_awa=acqres(2365000:2522000,:);
adi_awa=adires(2379000:2536000,:);
% align
acqres_align=acqres(1:2683000,:);
adires_align=adires(14001:2697000,:);
% plot
ana=[acq_ana(:,1) -adi_ana(:,1)];
ana=nc_normalize(ana);
plot(ana)
title(num2str(corr(ana)));
figure
awa=[acq_awa(:,1) -adi_awa(:,1)];
awa=nc_normalize(awa);
plot(awa)
title(num2str(corr(awa)));
figure
all=[acqres_align(:,1) -adires_align(:,1)];
all=nc_normalize(all);
plot(all)
title(num2str(corr(all)));