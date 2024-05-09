%% random seed
rng(66)
probs = zeros(2,2,2);
% prob of ramain the same status
pv = [0.7 0.75];
po = [0.7 0.75];
pvis = [pv(1) 1-pv(1);1-pv(2) pv(2)];
polf = [po(1) 1-po(1);1-po(2) po(2)];
probs(:,:,1) = pvis;
probs(:,:,2) = polf;
n = 10000;
% status 1 and 2
status = zeros(2,n);
% 1-vis 2-olf
status(1,1) = randperm(2,1);
status(2,1) = randperm(2,1);
for i=2:n
    % change pv and po according to previous status
    amount = 0.1;
    pon(status(1,i-1)) = min(1,po(status(1,i-1))+amount);
    pon(3-status(1,i-1)) = max(0,po(3-status(1,i-1))-amount);
    pvn(status(2,i-1)) = min(1,pv(status(2,i-1))+amount);
    pvn(3-status(2,i-1)) = max(0,pv(3-status(2,i-1))-amount);
    probs(:,:,1) = [pvn(1) 1-pvn(1);1-pvn(2) pvn(2)];
    probs(:,:,2) = [pon(1) 1-pon(1);1-pon(2) pon(2)];
    for p=1:2
        % a random number
        dice = rand(1);
        % the prob of current status
        [prob, idx]= max(probs(status(p,i-1),:,p)); 
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
combine = xor(status(1,:)-1,status(2,:)-1);
tabulate(combine)