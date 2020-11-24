function rseq = randseq( seq )
%randseq Generate random sequence for experiment

for i=1:10
rseq=sortrows([seq(:,1:3) randperm(length(seq))'],4);
end

end

