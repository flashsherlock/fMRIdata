function betas = betaCorrespondence()
%
%  betaCorrespondence.m is a simple function which should combine
%  three things: preBeta:	a string which is at the start of each file
%  containing a beta image, betas:	a struct indexed by (session,
%  condition) containing a sting unique to each beta image, postBeta:	a
%  string which is at the end of each file containing a beta image, not
%  containing the file .suffix
% 
%  use "[[subjectName]]" as a placeholder for the subject's name as found
%  in userOptions.subjectNames if necessary For example, in an experment
%  where the data from subject1 (subject1 name)  is saved in the format:
%  subject1Name_session1_condition1_experiment1.img and similarly for the
%  other conditions, one could use this function to define a general
%  mapping from experimental conditions to the path where the brain
%  responses are stored. If the paths are defined for a general subject,
%  the term [[subjectName]] would be iteratively replaced by the subject
%  names as defined by userOptions.subjectNames.
% 
%  note that this function could be replaced by an explicit mapping from
%  experimental conditions and sessions to data paths.
% 
%  Cai Wingfield 1-2010
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

preBeta = '[[subjectName]]_';

session=36;
s_name='exp';
condition=180/session;
odors={'lim' 'tra' 'car' 'cit' 'ind'};
labelname = reshape(repmat(odors,[36/session 1]),[condition 1]);
labelname = strcat(labelname,string(1:condition)');
betas(session,condition).identifier ='';
% betas(session, condition).identifier = ???
for session_i=1:session
    for condition_i=1:condition
    betas(session_i,condition_i).identifier = [s_name num2str(session_i) '_' ...
        labelname{condition_i}];
    postBeta = '';
    end
end

for session = 1:size(betas,1)
	for condition = 1:size(betas,2)
		betas(session,condition).identifier = [preBeta betas(session,condition).identifier postBeta];
	end%for
end%for

end%function
