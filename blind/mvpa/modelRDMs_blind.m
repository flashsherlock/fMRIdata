function Models = modelRDMs_blind(subjID,session,subjname)
if nargin < 3
    subjname = sprintf('S%02d',subjID);
end
% kron with k
k=192/session/8;
% odors={'gas','ind','ros','pin','app','min','fru','flo'};
% valence categories
Vacat = [0 0 1 1 1 1 1 1
         0 0 1 1 1 1 1 1
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0];
Vacat = Vacat'+Vacat;
Models.VAcat = kron(Vacat, ones(k, k));
% Fruit or Flower or neither
FF = [0 0 1 1 1 1 1 1
      0 0 1 1 1 1 1 1
      0 0 0 1 1 0 1 0
      0 0 0 0 0 1 0 1
      0 0 0 0 0 0 1 1
      0 0 0 0 0 0 1 0
      0 0 0 0 0 0 0 1
      0 0 0 0 0 0 0 0];
FF = FF'+FF;
Models.FFcat = kron(FF, ones(k,k));
% RDMs based on mri ratings
mrirating = blind_rate(subjname);
% valence
Models.vivid = kron(mrirating.vividRDM, ones(k,k));
% random
% Models.random = kron(squareform(pdist(rand(8, 8))), ones(k, k));
Models.random = squareform(pdist(rand(8*k, 8*k)));
end%function
