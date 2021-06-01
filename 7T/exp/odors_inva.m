function odors_inva(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% rate similarity
times=2;
% times
waittime=2;
cuetime=1.5;
odortime=2;
offset=1;
blanktime=0.5;
% ratetime=14;
iti=30;
jitter=2;

% fixation
fix_size=18;
fix_thick=3;
fixcolor_back=[0 0 0];
fixcolor_cue=[246 123 0]; %[211 82 48];
fixcolor_inhale=[0 154 70];  %[0 0 240];

% port
port='COM3';%COM3
% keys
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');
Key5 = KbName('6^');
Key6 = KbName('7&');
Key7 = KbName('8*');
Key8 = KbName('9(');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');

% rating instruction
imageSizex=100;
imageSizey=75;
StimSize=[0 0 imageSizex imageSizey];
StimSize_num=[0 0 315+260 70];
% StimSize_circle=[0 0 35 35];
StimSize_rect=[0 0 36 45];
distance=25;
% circle_w=2;
rect_w=2;
% feedbackSizex=75;
% feedbackSizey=75;
% StimSizef=[0 0 feedbackSizex feedbackSizey];
% block config
% odor seq
% odors=[7 8 9 10 11]-6;% controled by randrating
air=0;

% input
[subject, runnum] = inputsubinfo;
Screen('Preference', 'SkipSyncTests', 1);
if nargin < 2
    offcenter_x=0; offcenter_y=0;
end
% odor seq
% odors=[7 8 9 10 11]-6;
% air=0;
% odors=repmat(odors,[times 1]);
id=str2double(subject(end-1:end));
load('randrating.mat','vi')
id=min(size(vi,1),id);
id=max(1,id);
vi=vi(id,:);
odors=repmat(vi,[times 1]);
% rating 1 valence 2 intensity
rating=[ones(times/2,size(odors,2));ones(times/2,size(odors,2))*2];
% jitter
jitter=repmat(jitter',[2 size(odors,2)]);

% final seq
seq=[reshape(odors,[],1) reshape(rating,[],1) reshape(jitter,[],1)];
seq=randseq(seq);
seq=seq(:,1:3);
% double seq
% valence
seq(:,2)=2;
seq2=seq;
% intensity
seq(:,2)=1;
seq=[seq2;seq];

% record
result=zeros(length(seq),7);
result(:,1:3)=seq;
% record all keystrokes
response=cell(length(seq),2);

AssertOpenGL;
whichscreen=max(Screen('Screens'));
% backup resolution
oldResolution=Screen('Resolution', whichscreen);
Screen('Resolution', whichscreen, 800, 600);

% ettport
delete(instrfindall('Type','serial'));
ettport=ett('init',port);

% rand according to time
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end));
rng(tseed);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;

datafile=sprintf('Data%s%s_inva%s.mat',filesep,subject,datestr(now,30));

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y-distance);
% StimRectf=OffsetRect(CenterRect(StimSizef,rect),offcenter_x,offcenter_y+50);
StimRect_num=OffsetRect(CenterRect(StimSize_num,rect),offcenter_x-1,offcenter_y+distance);
% StimRect_circle=OffsetRect(CenterRect(StimSize_circle,rect),offcenter_x,offcenter_y+55);
choose=OffsetRect(CenterRect(StimSize_rect,rect),offcenter_x,offcenter_y+distance);
choose=repmat(choose,[7 1])';
choose([1 3],:)=choose([1 3],:)+repmat(((StimSize_num(3)-260)/7)*[-3:3],[2 1]);

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));
% load pictures
cd ins
% for i=1:7
%     feedback(i)=Screen('MakeTexture', windowPtr, imread([num2str(i) '.bmp']));    
% end
ins(1)=Screen('MakeTexture', windowPtr, imread('valence.bmp'));
ins(2)=Screen('MakeTexture', windowPtr, imread('intensity.bmp'));
number(1)=Screen('MakeTexture', windowPtr, imread('number1.bmp'));
number(2)=Screen('MakeTexture', windowPtr, imread('number2.bmp'));
cd ..
HideCursor;
ListenChar(2);      % turn off keyboard
ett('set',ettport,air); 
% start screen
msg=sprintf('Waiting for the trigger to start...');
errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, triggerKey, backcolor, white);
    if errinfo==1
		Screen('CloseAll');
        return
    end

tic;
zerotime=GetSecs;

% start
Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
Screen('Flip',windowPtr);

% wait time
WaitSecs(waittime);

for cyc=1:length(seq)/2
    
    odor=seq(cyc,1);
    
    % hint
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp2);
    vbl=Screen('Flip',windowPtr);
    starttime=GetSecs;
    result(cyc,4)=starttime-zerotime;
    
    % open
    WaitSecs(cuetime-offset);
    ett('set',ettport,odor);
    
    % offset
    % WaitSecs(offset);
    
    % inhale
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp2);
    vbl=Screen('Flip', windowPtr, vbl + (fps*cuetime-0.1)*ifi);
    trialtime=GetSecs;
    result(cyc,5)=trialtime-zerotime;
    
    % close 
    WaitSecs(odortime-offset);
    ett('set',ettport,air);    

    % offset
    WaitSecs(offset);
    
    % blank screen
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip', windowPtr);
    WaitSecs(blanktime);
    
    % rating
    point=7;
    % intensity first
    Screen('DrawTexture',windowPtr,ins(2),[],StimRect);
    Screen('DrawTexture',windowPtr,number(2),[],StimRect_num);
    Screen('FrameRect',windowPtr,black,choose(:,point),rect_w);
    vbl=Screen('Flip',windowPtr);
    lastsecs=0;
    while 1     
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2)];
        if touch && ismember(1,ifkey)             
            switch find(ifkey==1,1,'first')
                % right
                case 1
                    if secs-lastsecs>0.2 && ~ismember(2,response{cyc,1})
                    point=mod(point-1,7);
                    if point == 0
                        point =7;
                    end
                    response{cyc,1}=[response{cyc,1} 1];
                    response{cyc,2}=[response{cyc,2} secs-vbl];
                    Screen('DrawTexture',windowPtr,ins(2),[],StimRect);
                    Screen('DrawTexture',windowPtr,number(2),[],StimRect_num);
                    Screen('FrameRect',windowPtr,black,choose(:,point),rect_w);
                    Screen('Flip', windowPtr);
                    lastsecs=secs;
                    end
                % confirm
                case 2
                    if ~ismember(2,response{cyc,1})      
                    result(cyc,6)=point;
                    result(cyc,7)=secs-vbl;
                    response{cyc,1}=[response{cyc,1} 2];
                    response{cyc,2}=[response{cyc,2} result(cyc,7)];
                    break
                    end
            end
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      % open keyboard
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end
    
    % valence second
    [~,~,~]=KbReleaseWait;
    cyc=cyc+length(seq)/2;
    point=7;    
    Screen('DrawTexture',windowPtr,ins(1),[],StimRect);
    Screen('DrawTexture',windowPtr,number(1),[],StimRect_num);
    Screen('FrameRect',windowPtr,black,choose(:,point),rect_w);
    vbl=Screen('Flip',windowPtr);
    lastsecs=0;
    while 1     
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2)];
        if touch && ismember(1,ifkey)             
            switch find(ifkey==1,1,'first')
                % right
                case 1
                    if secs-lastsecs>0.2 && ~ismember(2,response{cyc,1})
                    point=mod(point-1,7);
                    if point == 0
                        point =7;
                    end
                    response{cyc,1}=[response{cyc,1} 1];
                    response{cyc,2}=[response{cyc,2} secs-vbl];
                    Screen('DrawTexture',windowPtr,ins(1),[],StimRect);
                    Screen('DrawTexture',windowPtr,number(1),[],StimRect_num);
                    Screen('FrameRect',windowPtr,black,choose(:,point),rect_w);
                    Screen('Flip', windowPtr);
                    lastsecs=secs;
                    end
                % confirm
                case 2
                    if ~ismember(2,response{cyc,1})      
                    result(cyc,6)=point;
                    result(cyc,7)=secs-vbl;
                    response{cyc,1}=[response{cyc,1} 2];
                    response{cyc,2}=[response{cyc,2} result(cyc,7)];
                    break
                    end
            end
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      % open keyboard
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end
    
    % if not the last trial
    if cyc~=length(seq)
    % count down iti
    timer=iti;
    Screen('TextSize', windowPtr, 32);
    [norm,~]=Screen('TextBounds', windowPtr, num2str(timer));
    count=OffsetRect(CenterRect(norm,rect),offcenter_x,offcenter_y);
    Screen('DrawText', windowPtr, num2str(timer),count(1),count(2),0);
    vbl = Screen('Flip', windowPtr);

    while GetSecs-vbl<iti
        % flip every 1 second
        if floor(GetSecs-vbl)>iti-timer+0.9
            timer=timer-1;
            Screen('TextSize', windowPtr, 32);
            [norm,~]=Screen('TextBounds', windowPtr, num2str(timer));
            count=OffsetRect(CenterRect(norm,rect),offcenter_x,offcenter_y);
            Screen('DrawText', windowPtr, num2str(timer),count(1),count(2),0);
            Screen('Flip', windowPtr);
        end
        [touch, ~, keyCode] = KbCheck;
        if touch && keyCode(escapeKey)
            ListenChar(0);      % open keyboard
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end
    
    % wait time 2s
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip',windowPtr);
    WaitSecs(waittime);    
    end
    
end

toc;
% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      %restore keyboard
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);
%save
save(datafile,'result','response');

% display results
int=zeros(2,5);
for i=1:5
    % valence
    temp=result(result(:,1)==i&result(:,2)==1,6);
    temp(temp==0)=nan;
    int(1,i)=nanmean(temp);
    % intensity
    temp=result(result(:,1)==i&result(:,2)==2,6);
    temp(temp==0)=nan;
    int(2,i)=nanmean(temp);
end
disp(int)

return