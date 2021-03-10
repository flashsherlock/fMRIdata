for subi=1%:3
    sub=sprintf('S%02d',subi);
    % disp(sub)
    
    % generate images
    
    % generate timings
    analyze_timing(sub);
    analyze_timing_rating(sub);
    analyze_rating(sub)
    % generate phy files
%     resp_savebio(sub);
%     unix('tcsh phy.tcsh')
%     resp_campare(sub)
end