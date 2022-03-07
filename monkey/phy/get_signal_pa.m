function [xphase, xamp] = get_signal_pa(resp, lfp, latency, freqs, bandwidth)
% return phase(resp+theta) and amplitude(theta+freqs)
    if ~exist('freqs','var')
        freqs=13:1:80;
    end
    if ~exist('bandwidth','var')
        bandwidth=1; 
    end       
    % filt respiration
    cfglp=[];
    cfglp.lpfilter = 'yes';
    cfglp.lpfilttype = 'fir';
    cfglp.lpfreq = 5;
    resp_l = ft_preprocessing(cfglp,resp);
    resp_l = get_signal(resp_l,latency);
    % filt theta lfp
    cfgbp=[];
    cfgbp.bpfilter = 'yes';
    cfgbp.bpfilttype = 'fir';
    cfgbp.bpfreq = [4 8];
    lfp_l = ft_preprocessing(cfgbp,lfp);
    lfp_l = get_signal(lfp_l,latency);
    % filt high frequency lfp
    signal_h=repmat(lfp_l,1,1+length(freqs));
    for freq_i=1:length(freqs)
        cfgbp.bpfreq = [freqs(freq_i)-bandwidth freqs(freq_i)+bandwidth];
        lfp_h = ft_preprocessing(cfgbp,lfp);
        lfp_h = get_signal(lfp_h,latency);
        signal_h(:,1+freq_i)=lfp_h;
    end
    % return phase and amplitude
    xphase = angle(hilbert([resp_l lfp_l]));
    xamp=abs(hilbert(signal_h));
end

% function to transform data
function signal = get_signal(lfp,latency)
% reshape data and concatenate trials
    cfg=[];
    cfg.keeptrials='yes';
    cfg.latency=latency;
    signal=ft_timelockanalysis(cfg,lfp);
    % time-channel(1)-trial
    signal=permute(signal.trial,[3,2,1]);
    % concatenate trials
    signal=reshape(signal,[],1);
end