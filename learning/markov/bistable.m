%% random seed
rng(100)
% prob of ramain the same status
pv = [0.7 0.75];
po = [0.8 0.85];
pvis = [pv(1) 1-pv(1);1-pv(2) pv(2)];
polf = [po(1) 1-po(1);1-po(2) po(2)];
n = 1000;
% status 1 and 2
status = zeros(2,n);
% 1-vis 2-olf
status(1,1) = randperm(2,1);
status(2,1) = randperm(2,1);
for i=2:n
    for p=1:2
        dice = rand(1);
        [prob, idx]= max(polf(status(p,i-1))); 
        % update stats
        if dice < prob
            status(p,i) = idx;
        else
            status(p,i) = 3-idx;
        end
    end
end
%% plot
figure
plot(status(:,1:100)')
tabulate(status(1,:))
tabulate(status(2,:))