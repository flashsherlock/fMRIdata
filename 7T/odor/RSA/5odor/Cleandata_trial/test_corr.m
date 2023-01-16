% load response patterns
mask = 'align';
modelfolder = '/Volumes/WD_F/gufei/7T_odor/results_RSA/5odor_rmpolort_trial/';
datafolder = '/Volumes/WD_F/gufei/7T_odor/results_RSA/5odor_rmbase_trial/';
if ~exist([datafolder 'Figures'],'dir')
    mkdir([datafolder 'Figures'])
end
load([datafolder 'ImageData/Cleandata_responsePatterns_' mask '.mat']);
load([modelfolder 'RDMs/Cleandata_Models.mat']);
% fields and subs
fields = fieldnames(responsePatterns);
subn = [4:11 13 14 16:18 19:29 31:34];
subs = cell(1,length(subn));
for sub_i = 1:length(subn)
    subs{sub_i} = sprintf('S%02d', subn(sub_i));
end

% plot the response pattern
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

% pariwise correlation for all subjects
colms = [];
cormat = [];
% reshape to ncon, if not 180
ncon = 5;
for sub_i = 1:length(subn)
    for field_i = 1:length(fields)
        cur_res = responsePatterns.(fields{field_i}).(subs{sub_i});
        % only reshape        
%         cur_res = reshape(cur_res,[],ncon);
        % average
        cur_res = reshape(cur_res,size(cur_res,1),[],ncon);
        cur_res = squeeze(mean(cur_res,2));
        % RDM
        cur_res = 1-corr(cur_res);
        % imagesc(cur_res)
        % colormap jet
        colms(:, field_i) = cur_res(triu(true(size(cur_res)), 1));
    end

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
end

% extract the correlation between rois and strut & val
represent = zeros(2,length(fields),length(subn));
for sub_i = 1:length(subn)
    represent(:, :, sub_i) = cormat([length(fields) + 1 length(fields) + 6], 1:length(fields), sub_i);
end
s={[1:size(represent,3)],[1:size(represent,3)/2],[size(represent,3)/2+1:size(represent,3)]};
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
    ylabel('Spearman correlation');
    legend({'Struture', 'Similarity'});
    title(['Conditions: ' num2str(ncon),' Sub: ' num2str(sub_i)])
    % save svg figure to data folder
    saveas(gcf, [datafolder 'Figures/' mask '_strut&val_' num2str(ncon) '_' num2str(sub_i) '.svg']);
end
close all
% export for ANOVA
repwide = permute(represent,[3 1 2]);
repwide = reshape(repwide,length(subn),[]);
names = reshape([strcat(fields,'_str') strcat(fields,'_val')]',[],1);