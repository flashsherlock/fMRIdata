function results=rclass(rdm)
% results are mean distances
% row 1 within class, 2 between class
% column 1 w&b run, 2 within run, 3 between run
results=zeros(2,3);
mask=cell(2,3);
size=length(rdm);
run=6;
trial=8;
odor=4;
% remove diagonal
d=eye(size);
all=ones(size)-d;
% within class
wclass=kron(eye(odor), ones(size/odor));
mask{1,1}=wclass-d;
% between class
mask{2,1}=all-mask{1,1};
% within class within run
wclasswrun=kron(eye(odor*run), ones(trial));
mask{1,2}=wclasswrun-d;
% within class between run
mask{1,3}=mask{1,1}-mask{1,2};
% between class within run
bclasswrun=kron(repmat(eye(run),[odor,odor]), ones(trial))-wclasswrun;
mask{2,2}=bclasswrun;
% between class between run
mask{2,3}=mask{2,1}-mask{2,2};
% plot masks
% figure;
for i=1:2
    for j=1:3
        % plot
%         import rsa.fig.*
%         import rsa.util.*
%         cols=RDMcolormap;        
%         subplot(2,3,(i-1)*3+j);
%         imagesc(scale01(rankTransform_equalsStayEqual(rdm.*mask{i,j},1)))
%         colormap(gca,cols); colorbar;
%         subplot(2,3,(i-1)*3+j);
%         imagesc(rdm.*mask{i,j});
        % compute mean distance
        results(i,j)=sum(sum(rdm.*mask{i,j}))/sum(sum(mask{i,j}));
    end
end
% plot results
% figure;
% b=bar(1-results');
% b(1).FaceColor=	[0 0.4470 0.7410];
% b(2).FaceColor=	[0.9290 0.6940 0.1250];
% legend('within-odor','between-odor','Location','eastoutside');
% set(gca,'XTickLabel',{'all','within-run','between-run'})
end