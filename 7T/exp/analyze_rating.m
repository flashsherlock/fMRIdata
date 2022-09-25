subs=[4 5 7 14 18:20 22 25 29:34 40 42:44];
datadir='Data';
ratings=zeros(length(subs),14);
rate = behrate(subs(1));
for subi = 1:length(subs)
    sub=sprintf('S%02d',subs(subi));
    % inva
    data=dir([datadir filesep lower(sub) '_inva*.mat']);
    load([datadir filesep data.name]);
    % display results
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

    % similarity
    data=dir([datadir filesep lower(sub) '_similarity*.mat']);
    load([datadir filesep data.name]);
    % get odornumber
    odornum=length(unique([result(:,1);result(:,2)]));
    % sort columns
    result(:,1:2)=sort(result(:,1:2),2);
    % sort rows
    result=sortrows(result,[1 2]);
    % reshape to 2 rows
    similarity=reshape(result(:,6),2,[]);
    % calculate means
    similarity(similarity==0)=nan;
    similarity=nanmean(similarity);
    % similarity for lim
    simlim=similarity(1:4);
    
    % practice
    if subi > 1
        rate = catfields(rate, behrate(subs(subi)));
    end
    
    ratings(subi,:)=[int(1,:) int(2,:) simlim];
end