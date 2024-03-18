function [repwide, p]= test_corr(mask, voxelnum)
%% load response patterns
% mask = 'at165';
% voxelnum = 0.05;
chosen = [1 6];
modelfolder = '/Volumes/WD_F/gufei/7T_odor/results_RSA/5odor_rmpolort_trial/';
datafolder = '/Volumes/WD_F/gufei/7T_odor/results_RSA/5odor_rmbase_trial/';
if ~exist([datafolder 'Figures'],'dir')
    mkdir([datafolder 'Figures'])
end
load([datafolder 'ImageData/Cleandata_responsePatterns_' mask '.mat']);
% load([modelfolder 'ImageData/Cleandata_responsePatterns.mat']);
load([modelfolder 'RDMs/Cleandata_Models.mat']);
subn = [4:11 13 14 16:18 19:29 31:34];
subs = cell(1,length(subn));
for sub_i = 1:length(subn)
    subs{sub_i} = sprintf('S%02d', subn(sub_i));
end
useavg = 0;
plotrdm = 0;
use30 = 0;
%% combine cortical and CeMe
responsePatterns.superAmy = responsePatterns.(['CeMeAmy_' mask]);
responsePatterns.deepAmy = responsePatterns.(['BaLaAmy_' mask]);
% for each field in superAmy
subfields = fieldnames(responsePatterns.superAmy);
for field_i = 1:length(subfields)
    responsePatterns.superAmy.(subfields{field_i}) = cat(1,responsePatterns.(['CeMeAmy_' mask]).(subfields{field_i}),responsePatterns.(['corticalAmy_' mask]).(subfields{field_i}));
end
% fields and subs
fields = fieldnames(responsePatterns);
%% plot the response pattern
% for field_i = 1:length(fields)    
%     % for each sub
%     for sub_i = 1:length(subn)
%         figure;
%         imagesc(responsePatterns.(fields{field_i}).(subs{sub_i}));
%         title([fields{field_i} ' : ' subs{sub_i}], 'Interpreter', 'none');
%         colormap gray
%         close all
%     end 
% end
%% use averaged sim RDM
if useavg == 1
    simavg = mean(cat(3,Models(6, :).RDM),3);
    for sub_i = 1:length(subn)
        Models(6, sub_i).RDM = simavg;
    end
end
%% use 30*30 valence and intensity
if use30 == 1
    for sub_i = 1:length(subn)
        [Models(4, sub_i).RDM Models(5, sub_i).RDM] = mrivi(subn(sub_i));
    end
end
%% pariwise correlation for all subjects
colms = [];
cormat = [];
betas = [];
neur = [];
% reshape to ncon, if not 180
ncon = 180;
perw = cell(length(subn),length(fields));
for sub_i = 1:length(subn)
    for field_i = 1:length(fields)
        cur_res = responsePatterns.(fields{field_i}).(subs{sub_i});
        % select voxels
        [cur_res,perw{sub_i,field_i}] = select_voxel(cur_res,voxelnum);
        % only reshape        
%         cur_res = reshape(cur_res,[],ncon);
        % average
        if ncon==30
            % average repeats
            cur_res = reshape(cur_res',6,ncon,[]);
            cur_res = squeeze(mean(cur_res,1))';
%             % average runs            
%             cur_res = reshape(cur_res',6,6,5,[]);
%             % repeat odor run
%             cur_res = permute(cur_res,[1 3 2 4]);
%             cur_res = reshape(cur_res,ncon,6,[]);
%             cur_res = squeeze(mean(cur_res,2))';
        else
            cur_res = reshape(cur_res,size(cur_res,1),[],ncon);
            cur_res = squeeze(mean(cur_res,2)); 
        end               
        % RDM
        cur_res = 1-corr(cur_res);
        % plot        
        if field_i==1 && plotrdm==1
            figure
            imagesc(cur_res)
            colormap jet
            title([num2str(subn(sub_i)) '-' fields{field_i}])   
        end
        % select upper triangle
        colms(:, field_i) = cur_res(triu(true(size(cur_res)), 1));
    end    
    % calculate RSA
    for m_i = 1:size(Models,1)
        cur_res = Models(m_i, sub_i).RDM;
        % select according to the size of response        
        index = zeros(180/ncon);
        index(1) = 1;
        index = kron(ones(ncon),index);
        cur_res = reshape(cur_res(index==1),ncon,ncon);
        colms(:, length(fields)+m_i) = cur_res(triu(true(size(cur_res)), 1));
    end
    cormat(:, :, sub_i) = corr(colms, 'type', 'Spearman');
    % extract lim-car lim-cit lim-tra lim-ind
%     select_r = [0.3871 0.7013 0.9583 0.9747];
%     for sr_i = 1:length(select_r)
%         idx = colms(:, length(fields)+1)==select_r(sr_i);
%         neur(sr_i,:,sub_i)=mean(colms(idx, 1:length(fields)));
%         % fisherz
%         neur(sr_i,:,sub_i)=mean(atanh(1-colms(idx, 1:length(fields))));
%     end
    % glmfit
%     for field_i = 1:length(fields)
%         % the first beta is constant term if not set 'constant','off'
%         colms = zscore(colms,0,1);
% %         models = [5,4,1,6];        
%         labels = {'APairs' 'Haddad' 'Odorspace' 'valence' 'intensity' 'similarity' 'random'};
%         models = [4,5];
%         betas1(field_i,:,sub_i) = glmfit(colms(:,length(fields)+models),colms(:,field_i),'normal')'; 
%         models = [4,5,1];
%         betas2(field_i,:,sub_i) = glmfit(colms(:,length(fields)+models),colms(:,field_i),'normal')';  
%         models = [4,5,6];
%         betas3(field_i,:,sub_i) = glmfit(colms(:,length(fields)+models),colms(:,field_i),'normal')';
%         models = [4,5,7];
%         betas4(field_i,:,sub_i) = glmfit(colms(:,length(fields)+models),colms(:,field_i),'normal')';
%     end
end
%% extract the correlation between rois and strut & sim
represent = zeros(2,length(fields),length(subn));
for sub_i = 1:length(subn)
    % 1-7 APairs Haddad Odorspace mrvalence mrintensity mrsimilarity random
    represent(:, :, sub_i) = cormat([length(fields) + chosen(1) length(fields) + chosen(2)], 1:length(fields), sub_i);
    % fisher-z
    represent(:, :, sub_i)=atanh(represent(:, :, sub_i));
end
% correlation between struct and sim
strsimr = cormat(length(fields) + chosen(1),length(fields) + chosen(2),:);
% split subs
s={[1:size(represent,3)],[1:size(represent,3)/2],[size(represent,3)/2+1:size(represent,3)]};
% split odd and even
% s={[1:size(represent,3)],1:2:size(represent,3),2:2:size(represent,3)};
select_rep = [1:length(fields)];
% select_rep = [1 5:length(fields)];
for sub_i=1%:3
    % average across subs
    repm = squeeze(mean(represent(:,select_rep,s{sub_i}), 3));    
    % plot mean and stand error
    figure('position', [20, 0, 1000, 300], 'Renderer', 'Painters');
    h = bar(repm');
    % set face colors to red and blue
    h(1).FaceColor = hex2rgb('#f0803b');
    h(2).FaceColor = hex2rgb('#56a2d4');
    set(gca,'TicklabelInterpreter','none')
    xl = strrep(strrep(fields(select_rep),['_' mask],''),'Amy','');
    xl = strrep(xl,'8','Amy');
    set(gca, 'XTickLabel', xl);
    set(gca, 'FontSize',18)
    ylabel('fisher-z r');
    legend({'Struture', 'Similarity'});
    title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])
    % save svg figure to data folder
    %saveas(gcf, [datafolder 'Figures/' mask '_' num2str(chosen(1)) '&' num2str(chosen(2)) '_' num2str(ncon) '_' num2str(sub_i) '.svg']);
end
% plot distances between lim-car lim-cit
% for sub_i=1%:3    
%     % average across subs
%     repm = squeeze(mean(neur(1:2,select_rep,s{sub_i}), 3));    
%     % plot mean and stand error
%     figure('position', [20, 0, 1000, 300], 'Renderer', 'Painters');
%     h = bar(repm');
%     % set face colors to red and blue
%     h(1).FaceColor = hex2rgb('#f0803b');
%     h(2).FaceColor = hex2rgb('#56a2d4');
%     set(gca,'TicklabelInterpreter','none')
%     xl = strrep(strrep(fields(select_rep),['_' mask],''),'Amy','');
%     xl = strrep(xl,'8','Amy');
%     set(gca, 'XTickLabel', xl);
%     set(gca, 'FontSize',18)
%     ylabel('1-r');
%     legend({'lim-car', 'lim-cit'});
%     title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])
%     % save svg figure to data folder
%     %saveas(gcf, [datafolder 'Figures/' mask '_' num2str(ncon) '.svg']);
% end
%close all
%% betas
% % remove constant term
% betas(:, 1:2, :) = betas1(:,2:3,:);
% % structure
% betas(:, 3, :) = betas2(:,4,:);
% % simlarity
% betas(:, 4, :) = betas3(:,4,:);
% % random
% betas(:, 5, :) = betas4(:,4,:);
% for sub_i=1%:3    
%     b = squeeze(mean(betas(:,:,s{sub_i}), 3));
%     figure('position', [20, 0, 1000, 300], 'Renderer', 'Painters');
%     h = bar(b);
%     % set face colors to red and blue
% %     h(1).FaceColor = hex2rgb('#f0803b');
% %     h(2).FaceColor = hex2rgb('#56a2d4');
%     set(gca,'TicklabelInterpreter','none')
%     set(gca, 'XTickLabel', xl);
%     set(gca, 'FontSize',18)
%     ylabel('Beta');
%     models = [4,5,1,6,7];
%     legend(labels(models));
%     title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])    
% end
%% plot perw
% perw = cellfun(@sort,perw,'UniformOutput',false);
% perw_mean = cellfun(@(x) mean(x(1:min(50,length(x)))),perw);
% [~,idx]=sort(mean(perw_mean,2));
% disp(subn(idx))
%% export for ANOVA
repwide = permute(represent,[3 1 2]);
repwide = reshape(repwide,length(subn),[]);
names = reshape([strcat(fields,'_str') strcat(fields,'_sim')]',[],1);
% repwide = repwide(idx,:);
% test interaction
p=zeros(1,3);
disp([mask num2str(voxelnum)])
[h,p(1),ci,t] = ttest((repwide(:,13)-repwide(:,14))-(repwide(:,17)-repwide(:,18)));
disp(names(13))
disp(p(1))
for roi_i =[15 19]    
    [h,p((roi_i-7)/4),ci,t] = ttest((repwide(:,roi_i)-repwide(:,roi_i+1))-(repwide(:,roi_i+2)-repwide(:,roi_i+3)));
    disp(names(roi_i))
    disp(p((roi_i-7)/4))
end
end