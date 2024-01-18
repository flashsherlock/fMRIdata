function OlfacVisuoEmoSuppExpFMRI_updated
% nblock = 16, Scan = 264s, TR = 2s, 132 TRss
% nblock = 24, Scan = 392s, TR = 2s, 196 TR
[subject, runnum, order, NoiseColor] = inputsubinfo;
% Screen('Preference', 'SkipSyncTests', 1);
% NoiseColor: Red(1),BlueGreen(2)

%% Prepare stimuli
% Setup
ntrial=5;
step=0.1;
origin=1.0;
span=1.5;
breaktime=6;
nblock=24; % nblock must be a multiple of 8
if NoiseColor==1
    RedInt=1.0; % noise intensity
    GreenInt=0.6; % face green intensity
    BlueInt=0.6; % face blue intensity
elseif NoiseColor==2
    RedInt=1.0;
    GreenInt=0.7;
    BlueInt=0.7;
end
types=10; % How many pictures under each condition.
NoiseSize=4; % The number is bigger, the size is smaller.
NoiseNum=200; % How many squares rectangles in a noise frame
CycleFrames=100; % How many noise frames
% Size
AssertOpenGL;
whichscreen=max(Screen('Screens'));
StimSizeFace=[0 0 70 104];
StimSizeFrame=[0 0 320 320];
StimSizeNoise=[0 0 260 260];
oldResolution=Screen('Resolution', whichscreen);
Screen('Resolution', whichscreen, 800, 600);
% Color
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)/2);
backcolor=black;
if NoiseColor==1
    fixcolor0=[100 0 0];
    fixcolor1=[255 0 0];
elseif NoiseColor==2
    fixcolor0=[0 100 100];
    fixcolor1=[0 255 255];
end
% Layout
Screen('Preference', 'SkipSyncTests', 1);
[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[centerx,centery]=RectCenter(rect);
fixposv=CenterRect([0 0 4 20],rect);
fixposh=CenterRect([0 0 20 4],rect);
fps=round(FrameRate(windowPtr));
ifi=Screen('GetFlipInterval',windowPtr);
waitframes=2;
% Image
defaultwin=Screen('MakeTexture', windowPtr, imread('BinocularFrame.bmp'));
for i=1:types 
    GreyFearfulFace=imread([int2str(i) '.jpg']);
    GreenFearfulFace=zeros(size(GreyFearfulFace));
    if NoiseColor==1
        GreenFearfulFace(:,:,2)=GreyFearfulFace(:,:,2)*GreenInt;
        GreenFearfulFace(:,:,3)=GreyFearfulFace(:,:,3)*BlueInt;
    elseif NoiseColor==2
        GreenFearfulFace(:,:,1)=GreyFearfulFace(:,:,1)*RedInt;
    end
    FearfulFace(i)=Screen('MakeTexture', windowPtr, GreenFearfulFace); 
    GreyHappyFace=imread([int2str(i+10) '.jpg']);
    GreenHappyFace=zeros(size(GreyHappyFace));
    if NoiseColor==1
        GreenHappyFace(:,:,2)=GreyHappyFace(:,:,2)*GreenInt;
        GreenHappyFace(:,:,3)=GreyHappyFace(:,:,3)*BlueInt;
    elseif NoiseColor==2
        GreenHappyFace(:,:,1)=GreyHappyFace(:,:,1)*RedInt;
    end
    HappyFace(i)=Screen('MakeTexture', windowPtr, GreenHappyFace);
end
FaceRect=Screen('Rect',HappyFace(1));
w=GenerateDynamicCFS_UMNVAL(StimSizeNoise(3), StimSizeNoise(4), CycleFrames, NoiseNum, NoiseSize, NoiseColor);
% Key
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');
% Sequence
% FaceCon=[1:2]; % fearful vs. happy
% SmellCon=[1:2]; % pleasant vs. unpleasant
% VisuoCon=[1:2]; % visible vs. invisible
% BlockSeq=zeros(nblock,3);
% BlockSeq(:,1)=repmat([FaceCon]',[length(SmellCon)*length(VisuoCon)*nblock/8,1]);
% BlockSeq(:,2)=repmat(reshape(ones(length(FaceCon),1)*[SmellCon],[length(FaceCon)*length(SmellCon),1]),[length(VisuoCon)*nblock/8,1]);
% BlockSeq(:,3)=repmat(reshape(ones(length(FaceCon)*length(SmellCon),1)*[VisuoCon],[length(FaceCon)*length(SmellCon)*length(VisuoCon),1]),[nblock/8,1]);
% BlockSeq=BlockSeq(Shuffle(1:size(BlockSeq,1)),:);
load(['BlockSeq' order '.mat']);
for i=1:nblock*ntrial/(types*2)
    FearfulFaceNum(:,i)=shuffle(1:length(FearfulFace))';
    HappyFaceNum(:,i)=shuffle(1:length(HappyFace))';
    StartupNum(:,i)=shuffle(origin:step:(origin+step*9))';
    StartupNum(:,i+nblock*ntrial/(types*2))=5;
end
FearfulFaceSeq=shuffle(reshape(FearfulFaceNum,size(FearfulFaceNum,1)*nblock*ntrial/(types*2),1));
HappyFaceSeq=shuffle(reshape(HappyFaceNum,size(HappyFaceNum,1)*nblock*ntrial/(types*2),1));
StartupSeq=shuffle(reshape(StartupNum,size(StartupNum,1)*nblock*ntrial/types,1));
results=zeros(nblock*ntrial,10);
% Port
port='4FF8';
port=hex2dec(port);
% % SmellTriggerA = [1 0 0]; % Chamber 1A
% % SmellTriggerA = [0 1 0]; % Chamber 2A
% % SmellTriggerA = [1 1 0]; % Chamber 3A
% % SmellTriggerA = [0 0 1]; % Chamber 4A
% % SmellTriggerA = [1 0 1]; % Chamber 5A
% % SmellTriggerA = [0 1 1]; % Chamber 6A
ChamberRose=[1 0 0];
ChamberFish=[0 1 0];
ChamberAir=[0 1 1];
RoseChamber=[ChamberRose 0 0 0];
FishChamber=[ChamberFish 0 0 0];
AirChamber=[ChamberAir 0 0 0];
RoseSmell=bin2dec(num2str(RoseChamber(end:-1:1)));
FishSmell=bin2dec(num2str(FishChamber(end:-1:1)));
Air=bin2dec(num2str(AirChamber(end:-1:1)));


%% Show stimuli

% HideCursor;

% lptwrite(port,0);
% WaitSecs(0.004);
% lptwrite(port,Air);

Screen(windowPtr,'FillRect',backcolor);
msg=sprintf('Waiting for the trigger to start...');
errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, triggerKey, backcolor, white);
    if errinfo==1
		Screen('CloseAll');
        return
    end

    
StartPoint=GetSecs;
oldPriority=Priority(MaxPriority(windowPtr));
Screen('DrawTexture',windowPtr,defaultwin);
vbl=Screen('Flip',windowPtr);
WaitSecs(7);
Nf=0;
Nh=0;
for block=1:nblock
    Screen('DrawTexture',windowPtr,defaultwin);
    Screen('FillRect',windowPtr,fixcolor0,fixposv);
    Screen('FillRect',windowPtr,fixcolor0,fixposh);
    vbl=Screen('Flip',windowPtr);
    WaitSecs(1);
    BlockStart(block)=GetSecs;
    % Smell
%     if BlockSeq(block,2)==1
%         lptwrite(port,RoseSmell);
%     elseif BlockSeq(block,2)==2
%         lptwrite(port,FishSmell);
%     end
    % Visual Stimuli
    for trial=1:ntrial
        TrialStart((block-1)*ntrial+trial)=GetSecs;
        results((block-1)*ntrial+trial,8)=BlockStart(block)-StartPoint;
        results((block-1)*ntrial+trial,9)=TrialStart((block-1)*ntrial+trial)-BlockStart(block);
        x=RandSample([-20:20]);
        y=RandSample([-20:20]);
        results((block-1)*ntrial+trial,1:3)=BlockSeq(block,1:3);
        results((block-1)*ntrial+trial,4)=StartupSeq((block-1)*ntrial+trial,1);
        if BlockSeq(block,1)==1
            Nf=Nf+1;
            face=FearfulFace(FearfulFaceSeq(Nf));
            facematrix=imread([int2str(FearfulFaceSeq(Nf)) '.jpg']);
            results((block-1)*ntrial+trial,5)=FearfulFaceSeq(Nf);
        elseif BlockSeq(block,1)==2
            Nh=Nh+1;
            face=HappyFace(HappyFaceSeq(Nh));
            facematrix=imread([int2str(HappyFaceSeq(Nh)) '.jpg']);
            results((block-1)*ntrial+trial,5)=HappyFaceSeq(Nh)+10;
        end
    trialtime=GetSecs;
    if BlockSeq(block,3)==1
        if StartupSeq((block-1)*ntrial+trial)<span
            disp([StartupSeq((block-1)*ntrial+trial) results((block-1)*ntrial+trial,4)])
            for i=1:round(fps*StartupSeq((block-1)*ntrial+trial)/waitframes)
                Screen('DrawTexture',windowPtr,defaultwin);
                Screen('DrawTexture',windowPtr,face,[],CenterRectOnPoint(FaceRect,centerx+x,centery+y));
                Screen('FillRect',windowPtr,fixcolor0,fixposv);
                Screen('FillRect',windowPtr,fixcolor0,fixposh);
                vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
                [touch, secs, keyCode] = KbCheck;
                if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                    results((block-1)*ntrial+trial,6)=1;
                    results((block-1)*ntrial+trial,7)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    break
                end
            end
            disp(GetSecs-trialtime)
            for i=1:round(fps*(span-StartupSeq((block-1)*ntrial+trial))/waitframes)
                Screen('DrawTexture',windowPtr,defaultwin);
                Screen('DrawTexture',windowPtr,face,[],CenterRectOnPoint(FaceRect,centerx+x,centery+y));
                Screen('FillRect',windowPtr,fixcolor1,fixposv);
                Screen('FillRect',windowPtr,fixcolor1,fixposh);
                vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
                [touch, secs, keyCode] = KbCheck;
                if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                    results((block-1)*ntrial+trial,6)=1;
                    results((block-1)*ntrial+trial,7)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    break
                end
            end
        else
            for i=1:round(fps*span/waitframes)
                Screen('DrawTexture',windowPtr,defaultwin);
                Screen('DrawTexture',windowPtr,face,[],CenterRectOnPoint(FaceRect,centerx+x,centery+y));
                Screen('FillRect',windowPtr,fixcolor0,fixposv);
                Screen('FillRect',windowPtr,fixcolor0,fixposh);
                vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
                [touch, secs, keyCode] = KbCheck;
                if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                    results((block-1)*ntrial+trial,6)=1;
                    results((block-1)*ntrial+trial,7)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    break
                end
            end
        end
    elseif BlockSeq(block,3)==2
        if StartupSeq((block-1)*ntrial+trial)<span
            for i=1:round(fps*StartupSeq((block-1)*ntrial+trial)/waitframes)
                if mod(i,round(fps/waitframes/10))==1
                nDNwin=RandSample(1:CycleFrames);
                end
                if NoiseColor==1
                    Image=w(:,:,:,nDNwin)*RedInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,2)=...
                        facematrix(:,:,2)*GreenInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,3)=...
                        facematrix(:,:,3)*BlueInt;
                elseif NoiseColor==2
                    Image=w(:,:,:,nDNwin)*BlueInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,1)=...
                        facematrix(:,:,1)*RedInt;
                end
                Imagewin=Screen('MakeTexture',windowPtr,Image);
                Screen('DrawTexture',windowPtr,defaultwin);
                Screen('DrawTexture',windowPtr,Imagewin);
                Screen('FillRect',windowPtr,fixcolor0,fixposv);
                Screen('FillRect',windowPtr,fixcolor0,fixposh);
                vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
                [touch, secs, keyCode] = KbCheck;
                if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                    results((block-1)*ntrial+trial,6)=1;
                    results((block-1)*ntrial+trial,7)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    break
                end
                Screen('Close',Imagewin);
            end
            for i=1:round(fps*(span-StartupSeq((block-1)*ntrial+trial))/waitframes)
                if mod(i,round(fps/waitframes/10))==1
                nDNwin=RandSample(1:CycleFrames);
                end
                if NoiseColor==1
                    Image=w(:,:,:,nDNwin)*RedInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,2)=...
                        facematrix(:,:,2)*GreenInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,3)=...
                        facematrix(:,:,3)*BlueInt;
                elseif NoiseColor==2
                    Image=w(:,:,:,nDNwin)*BlueInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,1)=...
                        facematrix(:,:,1)*RedInt;
                end
                Imagewin=Screen('MakeTexture',windowPtr,Image);
                Screen('DrawTexture',windowPtr,defaultwin);
                Screen('DrawTexture',windowPtr,Imagewin);
                Screen('FillRect',windowPtr,fixcolor1,fixposv);
                Screen('FillRect',windowPtr,fixcolor1,fixposh);
                vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
                [touch, secs, keyCode] = KbCheck;
                if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                    results((block-1)*ntrial+trial,6)=1;
                    results((block-1)*ntrial+trial,7)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    break
                end
                Screen('Close',Imagewin);
            end
        else
            for i=1:round(fps*span/waitframes)
                if mod(i,round(fps/waitframes/10))==1
                nDNwin=RandSample(1:CycleFrames);
                end
                if NoiseColor==1
                    Image=w(:,:,:,nDNwin)*RedInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,2)=...
                        facematrix(:,:,2)*GreenInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,3)=...
                        facematrix(:,:,3)*BlueInt;
                elseif NoiseColor==2
                    Image=w(:,:,:,nDNwin)*BlueInt;
                    Image(StimSizeNoise(4)/2+y-StimSizeFace(4)/2+1:StimSizeNoise(4)/2+y+StimSizeFace(4)/2,...
                        StimSizeNoise(3)/2+x-StimSizeFace(3)/2+1:StimSizeNoise(3)/2+x+StimSizeFace(3)/2,1)=...
                        facematrix(:,:,1)*RedInt;
                end
                Imagewin=Screen('MakeTexture',windowPtr,Image);
                Screen('DrawTexture',windowPtr,defaultwin);
                Screen('DrawTexture',windowPtr,Imagewin);
                Screen('FillRect',windowPtr,fixcolor0,fixposv);
                Screen('FillRect',windowPtr,fixcolor0,fixposh);
                vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
                [touch, secs, keyCode] = KbCheck;
                if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                    results((block-1)*ntrial+trial,6)=1;
                    results((block-1)*ntrial+trial,7)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    break
                end
                Screen('Close',Imagewin);
            end
        end        
    end
    cur=GetSecs;
    difftime=2-(cur-TrialStart((block-1)*ntrial+trial));
%     disp(difftime)
    for i=1:round(fps*difftime/waitframes)
        Screen(windowPtr,'FillRect',backcolor);
        Screen('DrawTexture',windowPtr,defaultwin);
        Screen('FillRect',windowPtr,fixcolor0,fixposv);
        Screen('FillRect',windowPtr,fixcolor0,fixposh);
        vbl=Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
        [touch, secs, keyCode] = KbCheck;
        if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
           results((block-1)*ntrial+trial,6)=1;
           results((block-1)*ntrial+trial,7)=secs-trialtime;
        elseif touch && keyCode(escapeKey)
           break
        end
    end
    end
    
%     lptwrite(port,Air);
    if block==nblock && trial==ntrial
        while ~(GetSecs-BlockStart(block)>=2*ntrial+breaktime)
            Screen('FillRect',windowPtr,backcolor);
            Screen('DrawTexture',windowPtr,defaultwin);
            vbl=Screen('Flip', windowPtr);
            [touch, secs, keyCode] = KbCheck;
            if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                results((block-1)*ntrial+trial,6)=1;
                results((block-1)*ntrial+trial,7)=secs-trialtime;
            elseif touch && keyCode(escapeKey)
                break
            end
        end
    else
        while ~(GetSecs-BlockStart(block)>=2*ntrial+breaktime-1);
            Screen('FillRect',windowPtr,backcolor);
            Screen('DrawTexture',windowPtr,defaultwin);
            vbl=Screen('Flip', windowPtr);
            [touch, secs, keyCode] = KbCheck;
            if touch && (keyCode(Key1) || keyCode(Key2) || keyCode(Key3) || keyCode(Key4))
                results((block-1)*ntrial+trial,6)=1;
                results((block-1)*ntrial+trial,7)=secs-trialtime;
            elseif touch && keyCode(escapeKey)
                break
            end
        end
    end
    [touch, secs, keyCode] = KbCheck;
    if touch && keyCode(escapeKey)
       break
    end
end

for i=1:size(results,1)
    if results(i,4)<span
        if results(i,6)==1 && results(i,7)>0.5
            results(i,10)=1;
        elseif i<size(results,1) && results(i,6)==0 && results(i+1,6)==1 && results(i+1,7)<=0.5
            results(i,10)=1;
        else
            results(i,10)=0;
        end
    else
        if i<size(results,1) && results(i,6)==0 && ~(results(i+1,6)==1 && results(i+1,7)<=0.5)
            results(i,10)=1;
        elseif i==size(results,1) && results(i,6)==0
            results(i,10)=1;
        else
            results(i,10)=0;
        end
    end
end

ACC=mean(results(:,10),1);
    
Screen('CloseAll');
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);
% Screen('Resolution', 1, 1920, 1200);
% ShowCursor;
datafile=sprintf('Data/%s_%s_%s_%s_%s',subject,runnum,order,mfilename,datestr(now,30));
save(datafile,'results','ACC','NoiseColor');
return