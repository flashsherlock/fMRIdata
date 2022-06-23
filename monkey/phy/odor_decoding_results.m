function odor_decoding_results(result_file, monkeys)
    %% load and reorganize data
    if length(monkeys) > 1
    m = '2monkey';
    else
        m = monkeys{1};
    end
    data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
    pic_dir=[data_dir 'pic/decoding/' m '/'];
    % result_file='decoding_results_odor.mat';
    load([pic_dir result_file]);
    %% analyze results
    for condition_i = 1:size(results,1)
        condition = results{condition_i,1};    
        % save results for this condition
        results_odor = results{condition_i,2};
        repeat_num = size(results_odor,2);
        roi_num = size(results_odor,1);
        % plot acc
        [acc, rois, chance]=odor_decoding_acc(results_odor);
        % ttest
        [h,p,ci,stats]=ttest(acc',chance);    
        % bar plot
        figure('position',[20 20 800 500])
        hold on
        bar(mean(acc,2))
        xnum = get(gca,'Xlim');
        plot(xnum,[chance chance],'r','linestyle','--','LineWidth',2)
        % add text
        for roi_i=1:roi_num
            % significance
            sig='';
            if p(roi_i)<0.001
                sig='***';
            elseif p(roi_i)<0.01
                sig='**';
            elseif p(roi_i)<0.05
                sig='*';
            end
            % accuracy star p-value
            text(roi_i,80,sprintf('%0.2f\n%s\n%0.3f',round(mean(acc(roi_i,:)),2),sig,round(p(roi_i),3)),...
                'Fontsize',12, 'VerticalAlignment','bottom', 'HorizontalAlignment','center')
        end
        set(gca,'ylim',[0 100])
        ylabel('ACC')
        xlabel('ROI')
        % set x label
        set(gca,'XTick',1:xnum(2)-1)
        set(gca,'XTickLabel',rois)
        % title avoid latex
        title([condition '   ' num2str(repeat_num) 'repeats   ' result_file],'Interpreter','none')
        % save figure
        saveas(gcf, [pic_dir condition '_' num2str(repeat_num) '.png'],'png')
    end
end