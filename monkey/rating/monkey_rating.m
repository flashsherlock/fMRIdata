%% parameters
datadir=['C:\Users/GuFei/zhuom/monkey/rating/'];
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
means_vi = [mean(rating.valence);mean(rating.intensity);mean(rating.familarity);mean(rating.edibility)];
sems_vi = [std(rating.valence);std(rating.intensity);std(rating.familarity);std(rating.edibility)]./sqrt(sub_num);
means_si = mean(rating.similarity);
sems_si = std(rating.similarity)./sqrt(sub_num);
