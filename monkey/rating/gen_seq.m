function seq = gen_seq(exp, seed)
% generate experiment sequence
% 1-indole 2-iso_l 3-iso_h 4-peach 5-banana
% set random seed
if nargin < 2
    % generate random seed according to current time
    ctime = datestr(now, 30);
    seed = str2num(ctime((end - 5):end));
end
rng(seed)

% number of odors
odornum = 5;
times = 2;
% generate sequence
switch exp
    case 'vi'
        seq = randvi(odornum, times);
    case 'si'
        seq = randsi(odornum);
    otherwise
        error('Should be vi or si!');
end

end

% generate sequence for val, int, fam, eat rating
function rseq = randvi(odornum, times)
    % generate sequence for valence and intensity rating
    % vi = kron([1:odornum]', ones(times,1));
    seq = kron(ones(times, 1), [1:odornum]');
    while 1
        % randomize the order of the stimuli
        rseq = seq(randperm(length(seq)));
        % change iso_l and iso_h to 6
        rseq_iso = rseq;
        rseq_iso(rseq_iso == 2 | rseq_iso == 3) = 6;
        % exclude same odors in consecutive 2 trials and ind in 1st trial
        if ~ismember(0, rseq_iso(2:end, 1) - rseq_iso(1: end - 1, 1))
            break
        end
    end
end

% generate sequence for similarity rating
function rseq = randsi(odornum)    
    % generate initial sequence
    comb = nchoosek(1:odornum, 2);     
    % randomize the order of the stimuli
    rseq = comb(randperm(size(comb,1)),:);
    % chenge the order of the odors in each trial
    rseq_rev = rseq(:,[2 1]);
    % revese the sequence OF rseq_rev
    rseq_rev = rseq_rev(end:-1:1,:);
    % combine rseq and rseq_rev
    rseq = [rseq; rseq_rev];
end