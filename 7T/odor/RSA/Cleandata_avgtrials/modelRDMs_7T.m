%  modelRDMs is a user-editable function which specifies the models which
%  brain-region RDMs should be compared to, and which specifies which kinds of
%  analysis should be performed.
%
%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%  
%  Cai Wingfield 11-2009

function Models = modelRDMs_7T(subjID,session,subjname)
% 
if nargin < 3
    subjname = sprintf('S%02d',subjID);
end
% kron with k
k=192/session/4;
% subjID = 1;
% NaN will be generated when plot MDS between models
% but if it kron ones(48,48), this problem will be avoid
% Models.allSeparate = kron([
% 			0 1 1 1
% 			1 0 1 1
% 			1 1 0 1
% 			1 1 1 0], ones(k,k));

% Models.quality = kron([
% 			0 1 1 0
% 			1 0 1 1
% 			1 1 0 1
% 			0 1 1 0], ones(k,k));
%         
% Models.structue = kron([
% 			0 1 0 1
% 			1 0 1 1
% 			0 1 0 1
% 			1 1 1 0], ones(k,k));

% atom pairs tanimoto
AP = [      0 1-0.0417 1-0.6129 1-0.2987
            0 0 1-0.0680 1-0.1224
            0 0 0 1-0.2360
            0 0 0 0];
AP = AP'+AP;
Models.APairs = kron(AP, ones(k,k));
% MCS tanimoto
MCS = [     0 1-0.2353 1-0.9091 1-0.75
            0 0 1-0.2222 1-0.2222
            0 0 0 1-0.6923
            0 0 0 0];
MCS = MCS'+MCS;
Models.MCSub = kron(MCS, ones(k,k));
% Haddad 2008
Haddad = [  0 6.18 4.42 4.27
            0 0 5.19 5.94
            0 0 0 3.63
            0 0 0 0];
Haddad = Haddad'+Haddad;
Models.Haddad = kron(Haddad, ones(k,k));
% odor space
odorspace = [  0 0.392 0.116 0.294
            0 0 0.383 0.264
            0 0 0 0.303
            0 0 0 0];
odorspace = odorspace'+odorspace;
Models.Odorspace = kron(odorspace, ones(k,k));
% RDMs based on mri ratings
mrirating = mrirate(subjname);
% valence
Models.mrvalence = kron(mrirating.valRDM, ones(k,k));
% intensity
Models.mrintensity = kron(mrirating.intRDM, ones(k,k));
% similarity
Models.mrsimilarity = kron(mrirating.simRDM, ones(k,k));
% RDMs based on bottle ratings
borating = bottlerate(subjID);
% valence
Models.bovalence = kron(borating.valRDM, ones(k,k));
% intensity
Models.bointensity = kron(borating.intRDM, ones(k,k));
% similarity
Models.bosimilarity = kron(borating.simRDM, ones(k,k));
% Models.bad_prototype = [kron([0 .5; .5 0], ones(16,16)) ones(32,32); ones(32,32), 1-eye(32,32)];
Models.random = squareform(pdist(rand(4,4)));

% Models.noStructure = ones(64,64);
% Models.noStructure(logical(eye(64)))=0;

end%function
