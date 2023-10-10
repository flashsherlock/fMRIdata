%% parameters
% datadir=['C:\Users/GuFei/zhuom/monkey/rating/'];
datadir=['/Volumes/WD_D/gufei/monkey_data/human_rating/inva/'];
filesi=dir([datadir '*similarity*.mat']);
filevi=dir([datadir '*inva*.mat']);
sub_num=size(filesi,1);
% odor_names={'indole', 'iso_l', 'iso_h', 'peach', 'banana'};
odor_names={'ind', 'isol', 'isoh', 'pea', 'ban'};
odor_num=length(odor_names);
% rating results
rating=struct('valence',zeros(sub_num,odor_num));
rating.intensity=rating.valence;
rating.familarity=rating.valence;
rating.edibility=rating.valence;
rating.similarity=zeros(sub_num,nchoosek(odor_num,2));
%% load data
for subi = 1:sub_num
    % similarity
    file_si=filesi(subi).name;
    load([datadir filesep file_si]);
    % change odors to 1-4 and sort columns
    result(:,1:2)=sort(result(:,1:2),2);
    % remove the first trial
    % result(1, 4) = nan;
    % sort rows
    result=sortrows(result,[1 2]);
    % reshape to 2 rows
    similarity=reshape(result(:,4),2,[]);
    % calculate means
    similarity(similarity==0)=nan;
    rating.similarity(subi,:)=nanmean(similarity);
    

    % intensity and valence
    file_vi = filevi(subi).name;
    load([datadir filesep file_vi]);
    % get odor labels
    odors=unique(result(:,1));
    % remove the first trial
    % result = result(2:end, :);
    for odori=1:length(odors)
        % caculate mean score
        % valence 4th colomn
        rating.valence(subi,odori) = mean(result(result(:, 1) == odors(odori), 4));
        % intensity 5th colomn
        rating.intensity(subi,odori) = mean(result(result(:, 1) == odors(odori), 5));
        % familarity 6th colomn
        rating.familarity(subi,odori) = mean(result(result(:, 1) == odors(odori), 6));
        % edibility 7th colomn
        rating.edibility(subi,odori) = mean(result(result(:, 1) == odors(odori), 7));
    end
end
%% calculate means
valence = rating.valence;
save('/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument/human_va.mat','valence')
all= [rating.valence, rating.intensity, rating.familarity, rating.edibility];
means_vi = [mean(rating.valence);mean(rating.intensity);mean(rating.familarity);mean(rating.edibility)];
sems_vi = [std(rating.valence);std(rating.intensity);std(rating.familarity);std(rating.edibility)]./sqrt(sub_num);
means_si = mean(rating.similarity);
sems_si = std(rating.similarity)./sqrt(sub_num);
%% iso
expected = sum(bsxfun(@gt,rating.intensity(:,3),rating.intensity(:,2)));
iso_in = mean(rating.intensity(:,2:3), 2);
iso_min = min(rating.intensity(:,2:3), [], 2);
iso_max = max(rating.intensity(:,2:3), [], 2);
% average intensity of iso is the max or min
% idx = bsxfun(@gt, iso_in, max(rating.intensity(:,[1 4 5]),[],2)) | bsxfun(@lt, iso_in, min(rating.intensity(:,[1 4 5]),[],2));
% more strict
idx = bsxfun(@gt, iso_min, max(rating.intensity(:,[1 4 5]),[],2)) | bsxfun(@lt, iso_max, min(rating.intensity(:,[1 4 5]),[],2));
% remove
intensity_new = rating.intensity(~idx,:);
[h,p]=ttest(intensity_new(:,2), intensity_new(:,3));
%% plot
% vi
figure;
hold on
alpha = 0.2;
colors = { '#7E2F8E', '#0072BD', '#D95319', '#EDB120'};
rnames = {'valence','intensity','familarity','edibility'};
for i=1:4
    stdshade(means_vi(i,:),sems_vi(i,:),alpha,hex2rgb(colors{i}));    
end
set(gca,'xtick',1:odor_num,'XTickLabel',odor_names,'FontSize',12)
legend(rnames,'Location','eastoutside')
% save figure
saveas(gcf, [datadir '../rating_4dim' '.svg'], 'svg')
saveas(gcf, [datadir '../rating_4dim' '.png'], 'png')
% si
figure;
stdshade(means_si,sems_si,alpha,hex2rgb(colors{1}));    
odor_pairs = odor_names(nchoosek(1:odor_num,2));
set(gca,'xtick',1:nchoosek(odor_num,2),'XTickLabel',strcat(odor_pairs(:,1),{'-'},odor_pairs(:,2)),...
    'xlim',[1 nchoosek(odor_num, 2)],'FontSize',12)
% save figure
saveas(gcf, [datadir '../rating_sim' '.svg'], 'svg')
saveas(gcf, [datadir '../rating_sim' '.png'], 'png')
% correlation
figure;
x = reshape(rating.edibility, [],1);
y = reshape(rating.valence, [], 1);
[r,p]=corr(x,y);
% scatter plot
scatter(x,y,'.')
xlabel('edibility')
ylabel('valence')
set(gca,'ylim',[1 100],'xlim',[1 100],'FontSize',12);
text(10,90,[sprintf('r=%0.2f, p=%0.3f',r,p)],'Fontsize',12)
%% RDMs
% 100-similarity as distance
d=mean(100-rating.similarity);
rating.simRDM=squareform(d);
% distances of 4 dimensions
% dis = 'euclidean';
dis = 'correlation';
rating.valRDM=pdist2(rating.valence',rating.valence',dis);
rating.intRDM=pdist2(rating.intensity',rating.intensity',dis);
rating.famRDM=pdist2(rating.familarity',rating.familarity',dis);
rating.ediRDM=pdist2(rating.edibility',rating.edibility',dis);
% save rating to mat file
save([datadir '../rating_inva.mat'],'rating')
%% ttest
for dim=1:2    
    % get the field for struct rating
    field = rnames{dim};
    disp(field)
    % get the data
    dimdata = rating.(field);
    [h,p,ci,stats]=ttest(dimdata(:,1),dimdata(:,2));
    disp(p)
    [h,p,ci,stats]=ttest(dimdata(:,1),dimdata(:,3));
    disp(p)
    [h,p,ci,stats]=ttest(dimdata(:,1),mean(dimdata(:,2:3),2));
    disp(p)
    [h,p,ci,stats]=ttest(dimdata(:,2),dimdata(:,3));
    disp(p)
    [h,p,ci,stats]=ttest(dimdata(:,4),dimdata(:,5));
    disp(p)
end