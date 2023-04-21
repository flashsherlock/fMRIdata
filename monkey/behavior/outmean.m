function [out, datnew] = outmean(dat,dim,n)
% calculate mean data excluded by n*std
    if nargin<3
        n=2;
    end
    if nargin<2
        dim=1;
    end
    datam = mean(dat,dim);
    datastd = std(dat,dim);
    % set outliers to nan
    dat(dat<(datam-n*datastd))=nan;
    dat(dat>(datam+n*datastd))=nan;
    datnew = dat;
    out = nanmean(dat,dim);
end