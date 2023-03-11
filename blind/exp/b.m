function b( f,vol )
% make beep
if nargin<2
    vol=1;
end
% Perform basic initialization of the sound driver:
InitializePsychSound;
% open sound device
device = [];
freq = 48000;
pahandle = PsychPortAudio('Open', device, [], 0, freq, 2);
PsychPortAudio('Volume', pahandle, 1);
% beep
beep_du = 2;
beep = MakeBeep(f, beep_du,freq);
beep = [beep; beep];
beep = beep*vol;
PsychPortAudio('FillBuffer', pahandle, beep);
PsychPortAudio('Start', pahandle, 1, 0, 1);
PsychPortAudio('Stop', pahandle, 1);  
end

