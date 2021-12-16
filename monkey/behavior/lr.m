data_dir='/Volumes/WD_D/gufei/flow/';
% sample rate
sprate=1000;
subs=2:8;
diff_lr=zeros(length(subs),2);
diff_lr_block=zeros(2,2,length(subs));
for sub_i=1:length(subs)
sub=subs(sub_i);
load([data_dir 'lr' num2str(sub) '.mat'])
left_flow=data(datastart(1):dataend(1));
right_flow=data(datastart(2):dataend(2));
% left-right
diff_flow=(abs(left_flow)-abs(right_flow))./(abs(left_flow)+abs(right_flow));
% plot(diff_flow);
% marker
marker=data(datastart(3):dataend(3));
% plot(marker)
% plot(diff(marker))
% block info
switch subs(sub_i)
    case {5 7}
        block_order=[2 1 1 2];%1-left
    otherwise
        block_order=[1 2 2 1];%1-left
end
block_left=find(block_order==1);
block_right=find(block_order==2);
block_start=find(marker(1:end-1)<1.02&marker(2:end)>=1.02)+1;
if length(block_start)~=4
    error('wrong block number');
end
block_end=block_start+sprate*30;
% cut to left and right
diff_flow_left=[];
diff_flow_right=[];
for i=1:length(block_left)
    diff_flow_left=[diff_flow_left diff_flow(block_start(block_left(i)):block_end(block_left(i)))];
    diff_lr_block(i,1,sub_i)=mean(diff_flow(block_start(block_left(i)):block_end(block_left(i))));
    diff_flow_right=[diff_flow_right diff_flow(block_start(block_right(i)):block_end(block_right(i)))];
    diff_lr_block(i,2,sub_i)=mean(diff_flow(block_start(block_right(i)):block_end(block_right(i))));
end
% % plot
% figure
% plot(diff_flow_left)
% hold on
% plot(diff_flow_right)
% average
diff_mean_left=mean(diff_flow_left);
diff_mean_right=mean(diff_flow_right);
diff_lr(sub_i,1)=diff_mean_left;
diff_lr(sub_i,2)=diff_mean_right;
% results for each block
disp(sub_i);
disp(diff_lr_block(:,:,sub_i));
end
disp(mean(diff_lr_block,3));
figure
bar(mean(diff_lr_block,3))
xlabel('block')
ylabel('(Left-Right)/(Left+Right)')
legend('Attend-left','Attend-right')
set(gca,'linewidth',1,'fontsize',20,'fontname','Times');

disp(diff_lr);
figure
bar(diff_lr)
xlabel('subject')
ylabel('(Left-Right)/(Left+Right)')
legend('Attend-left','Attend-right')
%% optic flow
disp('optic flow');
data_dir='/Volumes/WD_D/gufei/flow/';
sprate=1000;
% subs=2:6;
subs=[71:72 81:83 91:93];
diff_opflow=zeros(length(subs),2);
diff_opflow_block=zeros(5,2,length(subs));
for sub_i=1:length(subs)
sub=subs(sub_i);
% sample rate
load([data_dir 'flow' num2str(sub) '.mat'])
left_flow=data(datastart(1):dataend(1));
right_flow=data(datastart(2):dataend(2));
% left-right
diff_flow=(abs(left_flow)-abs(right_flow))./(abs(left_flow)+abs(right_flow));
% plot(diff_flow);
% marker
marker=data(datastart(3):dataend(3));
% block info
% load([data_dir 'Opticaflow_0' num2str(sub) '_0_1.mat'])
load([data_dir 'Opticaflow_0' num2str(floor(sub/10)) '_' num2str(mod(sub,10)) '_1.mat'])
block_order=output.heading;%2-left
angle=unique(abs(block_order));
block_left=find(block_order==angle);
block_right=find(block_order==-angle);
block_start=find(marker(1:end-1)<1.02&marker(2:end)>=1.02)+1;
if length(block_start)~=10
    error('wrong block number');
end
block_end=block_start+sprate*15;
% cut to left and right
diff_flow_left=[];
diff_flow_right=[];
for i=1:length(block_left)
    diff_flow_left=[diff_flow_left diff_flow(block_start(block_left(i)):block_end(block_left(i)))];
    diff_opflow_block(i,1,sub_i)=mean(diff_flow(block_start(block_left(i)):block_end(block_left(i))));
    diff_flow_right=[diff_flow_right diff_flow(block_start(block_right(i)):block_end(block_right(i)))];
    diff_opflow_block(i,2,sub_i)=mean(diff_flow(block_start(block_right(i)):block_end(block_right(i))));
end
% % plot
% figure
% plot(diff_flow_left)
% hold on
% plot(diff_flow_right)
% average
diff_mean_left=mean(diff_flow_left);
diff_mean_right=mean(diff_flow_right);
diff_opflow(sub_i,1)=diff_mean_left;
diff_opflow(sub_i,2)=diff_mean_right;
% results for each block
disp(sub_i);
disp(diff_opflow_block(:,:,sub_i));
end
% average results for each block (remove 1st sub)
block_avg=mean(diff_opflow_block(:,:,2:end),3);
disp(block_avg);
figure
bar(block_avg)
xlabel('block')
ylabel('(Left-Right)/(Left+Right)')
legend('Move-left','Move-right')

disp(diff_opflow);
figure
bar(diff_opflow(1:end,:))
xlabel('subject')
ylabel('(Left-Right)/(Left+Right)')
legend('Move-left','Move-right')
% figure
% bar(diff_opflow(2:end,:))
% xlabel('subject')
% ylabel('(Left-Right)/(Left+Right)')
% legend('Move-left','Move-right')
% set(gca,'xticklabel',{'2', '3','4','5'})
set(gca,'linewidth',1,'fontsize',20,'fontname','Times');