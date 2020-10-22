function  [p,st] = chit( data,cutl,cutr,exp )
%chit chi square test
%   根据cut分割数据并进行卡方检验
% left
left=data(data(:,2)<cutl,2);
lleft=length(left);
% right
right=data(data(:,2)>cutr,2);
lright=length(right);
% chisquare test
x=[left;right];
if nargin < 4
    exp=mean([lleft lright]);
    exp=[exp exp];
else
    exp=exp/sum(exp)*sum([lleft lright]);
end
[~,p,st] = chi2gof(x,'Expected',exp,'Edges',[0,mean([cutl cutr]),200]);
% disp([cutl cutr lleft lright]);
% out=[ lleft,lright ];
end

