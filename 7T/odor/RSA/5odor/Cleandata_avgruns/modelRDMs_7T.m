%  modelRDMs is a user-editable function which specifies the models which
%  brain-region RDMs should be compared to, and which specifies which kinds of
%  analysis should be performed.
%
%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%  
%  Cai Wingfield 11-2009

function Models = modelRDMs_7T()
subjID = 1;
% NaN will be generated when plot MDS between models
% but if it kron ones(48,48), this problem will be avoid
Models.allSeparate = kron([
			0 1 1 1
			1 0 1 1
			1 1 0 1
			1 1 1 0], ones(6,6));

Models.quality = kron([
			0 1 1 0
			1 0 1 1
			1 1 0 1
			0 1 1 0], ones(6,6));
        
Models.structue = kron([
			0 1 0 1
			1 0 1 1
			0 1 0 1
			1 1 1 0], ones(6,6));
% atom pairs tanimoto
AP = [      0 1-0.0417 1-0.6129 1-0.2987
            0 0 1-0.0680 1-0.1224
            0 0 0 1-0.2360
            0 0 0 0];
AP = AP'+AP;
Models.APairs = kron(AP, ones(6,6));
% MCS tanimoto
MCS = [      0 1-0.2353 1-0.9091 1-0.75
            0 0 1-0.2222 1-0.2222
            0 0 0 1-0.6923
            0 0 0 0];
MCS = MCS'+MCS;
Models.MCSub = kron(MCS, ones(6,6));
% RDMs based one ratings
rating = read_rating(subjID);
valence = rating(:,1);
intensity = rating(:,2);
% valence
Models.valence = kron(pdist2(valence,valence), ones(6,6));
% intensity
Models.intensity = kron(pdist2(intensity,intensity), ones(6,6));
% perception based on valence and intensity
Models.rating = kron(pdist2(rating,rating), ones(6,6));

% Models.bad_prototype = [kron([0 .5; .5 0], ones(16,16)) ones(32,32); ones(32,32), 1-eye(32,32)];
Models.random = squareform(pdist(rand(24,24)));

% Models.noStructure = ones(64,64);
% Models.noStructure(logical(eye(64)))=0;

end%function
