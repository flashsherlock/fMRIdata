%% load response patterns
mask = 'align';
modelfolder = '/Volumes/WD_F/gufei/blind/results_RSA/8odor_trial/';
datafolder = '/Volumes/WD_F/gufei/blind/results_RSA/8odor_trial/';
if ~exist([datafolder 'Figures'],'dir')
    mkdir([datafolder 'Figures'])
end
load([datafolder 'ImageData/Cleandata_responsePatterns_' mask '.mat']);
load([modelfolder 'RDMs/Cleandata_Models.mat']);
% fields and subs
fields = fieldnames(responsePatterns);
subn = [2:4,6:14,16];
subs = cell(1,length(subn));
for sub_i = 1:length(subn)
    subs{sub_i} = sprintf('S%02d', subn(sub_i));
end
useavg = 0;
plotrdm = 0;
%% plot the response pattern
% for field_i = 1:length(fields)    
%     % for each sub
%     for sub_i = 1:length(subn)
%         figure;
%         imagesc(responsePatterns.(fields{field_i}).(subs{sub_i}));
%         title([fields{field_i} ' : ' subs{sub_i}], 'Interpreter', 'none');
%         colormap jet
%         close all
%     end 
% end
%% use averaged sim RDM
% if useavg == 1
%     simavg = mean(cat(3,Models(6, :).RDM),3);
%     for sub_i = 1:length(subn)
%         Models(6, sub_i).RDM = simavg;
%     end
% end
%% pariwise correlation for all subjects
colms = [];
cormat = [];
betas = [];
catavg = [];
% reshape to ncon, if not 192
ncon = 48;
perw = cell(length(subn),length(fields));
for sub_i = 1:length(subn)
    for field_i = 1:length(fields)
        cur_res = responsePatterns.(fields{field_i}).(subs{sub_i});
        % select voxels
        [cur_res,perw{sub_i,field_i}] = select_voxel(cur_res,1,0,0);
        % only reshape        
%         cur_res = reshape(cur_res,[],ncon);
        % average
        if ncon==48
            % average repeats
            cur_res = reshape(cur_res',4,ncon,[]);
            cur_res = squeeze(mean(cur_res,1))';
%             % average runs            
%             cur_res = reshape(cur_res',4,6,8,[]);
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
    
    for m_i = 1:size(Models,1)
        cur_res = Models(m_i, sub_i).RDM;
        % select according to the size of response        
        index = zeros(192/ncon);
        index(1) = 1;
        index = kron(ones(ncon),index);
        cur_res = reshape(cur_res(index==1),ncon,ncon);
        colms(:, length(fields)+m_i) = cur_res(triu(true(size(cur_res)), 1));
    end
    cormat(:, :, sub_i) = corr(colms, 'type', 'Spearman');
    % average each category
    for field_i = 1:length(fields)
        for model_i = 1:2
            b_indx = colms(:,length(fields)+model_i)==1;
            w_indx = colms(:,length(fields)+model_i)==0;
            catavg(model_i,field_i,sub_i) = mean(colms(b_indx,field_i))-mean(colms(w_indx,field_i));
            % normalize
            catavg(model_i,field_i,sub_i) = catavg(model_i,field_i,sub_i)/mean(colms(:,field_i));
        end
    end
    % glmfit
    for field_i = 1:length(fields)
        % the first bet is constant term if not set 'constant','off'
        models = [1,2];
        labels = {'VAcat' 'FruFlo'};
        betas(field_i,:,sub_i) = glmfit(colms(:,length(fields)+models),colms(:,field_i),'normal')';        
    end
end
%% extract the correlation between rois and strut & sim
represent = zeros(2,length(fields),length(subn));
chosen = [1 2];
for sub_i = 1:length(subn)
    % 1-3 VAcat FruFlo random
    represent(:, :, sub_i) = cormat([length(fields) + chosen(1) length(fields) + chosen(2)], 1:length(fields), sub_i);
    % fisher-z
    represent(:, :, sub_i)=atanh(represent(:, :, sub_i));
end
% correlation between struct and sim
strsimr = cormat(length(fields) + chosen(1),length(fields) + chosen(2),:);
% split subs
% s={[1:size(represent,3)],[1:size(represent,3)/2],[size(represent,3)/2+1:size(represent,3)]};
% split odd and even
s={[1:size(represent,3)],1:2:size(represent,3),2:2:size(represent,3)};
for sub_i=1:3
    % average across subs
    repm = squeeze(mean(represent(:,:,s{sub_i}), 3));    
    % plot mean and stand error
    figure('position', [20, 0, 1000, 300], 'Renderer', 'Painters');
    h = bar(repm');
    % set face colors to red and blue
    h(1).FaceColor = hex2rgb('#f0803b');
    h(2).FaceColor = hex2rgb('#56a2d4');
    set(gca,'TicklabelInterpreter','none')
    xl = strrep(strrep(fields,['_' mask],''),'Amy','');
    xl = strrep(xl,'8','Amy');
    set(gca, 'XTickLabel', xl);
    set(gca, 'FontSize',18)
    ylabel('fisher-z r');
    legend({'VAcat' 'FruFlo'});
    title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])
    % save svg figure to data folder
    saveas(gcf, [datafolder 'Figures/' mask '_' num2str(chosen(1)) '&' num2str(chosen(2)) '_' num2str(ncon) '_' num2str(sub_i) '.svg']);
end
%% plot catavg
ps=[];
for sub_i=1:3
    % ttest
    [~,ps(1,:,sub_i),~,~]=ttest(squeeze(catavg(1,:,s{sub_i}))');
    [~,ps(2,:,sub_i),~,~]=ttest(squeeze(catavg(2,:,s{sub_i}))');
    % average across subs
    repm = squeeze(mean(catavg(:,:,s{sub_i}), 3));    
    % plot mean and stand error
    figure('position', [20, 0, 1000, 300], 'Renderer', 'Painters');
    h = bar(repm');
    % set face colors to red and blue
    h(1).FaceColor = hex2rgb('#f0803b');
    h(2).FaceColor = hex2rgb('#56a2d4');
    set(gca,'TicklabelInterpreter','none')
    xl = strrep(strrep(fields,['_' mask],''),'Amy','');
    xl = strrep(xl,'8','Amy');
    set(gca, 'XTickLabel', xl);
    set(gca, 'FontSize',18)
    ylabel('between-within');
    legend({'VAcat' 'FruFlo'});
    title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])
    % save svg figure to data folder
    % saveas(gcf, [datafolder 'Figures/' mask '_cat_' num2str(ncon) '_' num2str(sub_i) '.svg']);
end
%close all
%% betas
% remove constant term
betas(:, 1, :) = [];
for sub_i=1:3    
    b = squeeze(mean(betas(:,:,s{sub_i}), 3));
    figure('position', [20, 0, 1000, 300], 'Renderer', 'Painters');
    h = bar(b);
    % set face colors to red and blue
%     h(1).FaceColor = hex2rgb('#f0803b');
%     h(2).FaceColor = hex2rgb('#56a2d4');
    set(gca,'TicklabelInterpreter','none')
    set(gca, 'XTickLabel', xl);
    set(gca, 'FontSize',18)
    ylabel('Beta');
    legend(labels(models));
    title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])    
end
%% plot perw
perw = cellfun(@sort,perw,'UniformOutput',false);
perw_mean = cellfun(@(x) mean(x(1:min(50,length(x)))),perw);
[~,idx]=sort(mean(perw_mean,2));
disp(subn(idx))
%% export for ANOVA
repwide = permute(represent,[3 1 2]);
repwide = reshape(repwide,length(subn),[]);
names = reshape([strcat(fields,'_str') strcat(fields,'_sim')]',[],1);
repwide = repwide(idx,:);