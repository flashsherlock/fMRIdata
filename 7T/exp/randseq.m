function rseq = randseq( seq )
%randseq Generate random sequence for experiment
odors= unique(seq(:,1));
while 1
    rseq=sortrows([seq(:,1:3) randperm(length(seq))'],4);
%     inter=ones(length(odors),1);
%     
%     for i=1:length(odors)
%         rate=rseq(rseq(:,1)==odors(i),2);
%         inter(i)=ismember(0,rate(2:end)-rate(1:end-1));
%     end

    if ~ismember(0,rseq(2:end,1)-rseq(1:end-1,1))
            for i=1:length(odors)
                l=length(rseq(rseq(:,1)==odors(i),2));
                rseq(rseq(:,1)==odors(i),2)=repmat(randperm(2)',l/2,1);                
            end
        break
    end
end

end

