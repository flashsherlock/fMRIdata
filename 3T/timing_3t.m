function timing_3t( sub )
times=[3 8];
if nargin<2
    run=5;
end

datadir=['/Volumes/WD_D/allsub/behavior/'];
outdatadir = ['/Volumes/WD_F/gufei/3T_cw/' sub '/behavior/'];
if ~exist(outdatadir,'dir')
    mkdir(outdatadir);
end
timing=zeros(run,times(1),times(2));
% change sub to match filename
sub=[lower(sub) '_'];

for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load([datadir filesep dataname]);
    % convert condtion coding
    results=results(1:5:end,:);
    condition=results(:,1:3);
    condition=(condition-1)*[4;2;1]+1;
    % odor numbers   
    odors=unique(condition);    
    % for each odor, find timing
    for oi=1:length(odors)
        odor=odors(oi);        
        inhale=results(condition==odor,8)';
        timing(i,:,oi)=inhale;
    end
    
end

names={'FearPleaVis';'FearPleaInv';'FearUnpleaVis';'FearUnpleaInv';...
    'HappPleaVis';'HappPleaInv';'HappUnpleaVis';'HappUnpleaInv'};
for i=1:times(2)
    % timing for each odor(all runs)
    dlmwrite([outdatadir filesep names{i} '.txt'],timing(:,:,i),'delimiter',' ');
    dlmwrite([outdatadir filesep names{i} '_11s.txt'],timing(:,:,i)-1,'delimiter',' ');    
    % timing for each odor(each run)
%     for runi=1:run
%         dlmwrite([outdatadir filesep names{i} '_run_' num2str(runi) '.txt'],timing(runi,:,i),'delimiter',' ');
%     end
end
% fixation
fix = sort(reshape(timing,run,times(1)*times(2))-1,2);
dlmwrite([outdatadir filesep 'fix' '.txt'],fix,'delimiter',' ');
% fixation
fixoff = sort(reshape(timing,run,times(1)*times(2))+9.5,2);
dlmwrite([outdatadir filesep 'fixoff' '.txt'],fixoff,'delimiter',' ');
% frame
frame = [zeros(run,1),sort(reshape(timing,run,times(1)*times(2))+10,2)];
framet = [7*ones(run,1),5*ones(run,size(frame,2)-2),6*ones(run,1)];
for i=1:run
    ftime(i,:) = strcat(strsplit(num2str(frame(i,:))),{':'},strsplit(num2str(framet(i,:))));
end
fid=fopen([outdatadir filesep 'frame' '.txt'],'w');
    for i=1:run
        temp=strjoin(ftime(i,:));
        fprintf(fid,'%s\r\n',temp);
    end
fclose(fid);
% duration modulated fixation
dufix = sort([fix fix+10.5],2);
dufixt = kron(ones(run,size(fix,2)),[1,0.5]);
for i=1:run
    fixtime(i,:) = strcat(strsplit(num2str(dufix(i,:))),{':'},strsplit(num2str(dufixt(i,:))));
end
fid=fopen([outdatadir filesep 'fixdu' '.txt'],'w');
    for i=1:run
        temp=strjoin(fixtime(i,:));
        fprintf(fid,'%s\r\n',temp);
    end
fclose(fid);
% remove timing for each run
% unix(['rm ' outdatadir filesep '*run*.txt'])
end

