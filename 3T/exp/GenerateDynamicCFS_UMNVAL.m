function DN=GenerateDynamicCFS_UMNVAL(NoiseSizex, NoiseSizey, CycleFrames, NoiseNum, NoiseSize, NoiseColor)
% This program generates NoiseSizeynamic CFS
% DN = GenerateDynamicCFS_UMNVAL(windowPtr, NoiseSizex, NoiseSizey,
% CycleFrames, BackColor, FrontColor)
% DN = GenerateDynamicCFS_UMNVAL(100, 100, 60)
% Yi Jiang, Vision and Attention Lab, University of Minnesota

DN=zeros(NoiseSizey,NoiseSizex,3,CycleFrames);
iter=NoiseNum;
patchcolors=[0:255];
% patchcolors=[255 0 0; 255 255 0; 0 255 0; 0 0 255; 255 0 128; 0 255 255;...
%     255 128 0; 128 0 255; 0 128 255; 128 0 128];

% textwidth=ShowProgressBar_UMNVAL(windowPtr, BackColor, FrontColor, 0, [],...
%     ['Generating dynamic CFS noise ...']);
% h = waitbar(0,'Generating Dynamic CFS ...');
for i=1:CycleFrames
for j=1:iter
    NoisePatchCenter=[RandSample(1:NoiseSizey) RandSample(1:NoiseSizex)];
    NoisePatchSize=round([RandSample(1:NoiseSizey/4) RandSample(1:NoiseSizex/4)]/NoiseSize);
    NoisePatch(1:2)=[max(1,NoisePatchCenter(1)-NoisePatchSize(1))...
        min(NoiseSizey,NoisePatchCenter(1)+NoisePatchSize(1))];
    NoisePatch(3:4)=[max(1,NoisePatchCenter(2)-NoisePatchSize(2))...
        min(NoiseSizex,NoisePatchCenter(2)+NoisePatchSize(2))];
    if NoiseColor==1
        DN(NoisePatch(1):NoisePatch(2),NoisePatch(3):NoisePatch(4),1,i)=Sample(patchcolors);
    elseif NoiseColor==2
        DN(NoisePatch(1):NoisePatch(2),NoisePatch(3):NoisePatch(4),2:3,i)=Sample(patchcolors);
    end
%         repmat(reshape(Sample(patchcolors),[1,1,3]),...
%         [NoisePatch(2)-NoisePatch(1)+1,NoisePatch(4)-NoisePatch(3)+1,1]);
end
%     textwidth=ShowProgressBar_UMNVAL(windowPtr, BackColor, FrontColor,...
%         i/CycleFrames, textwidth, ['Generating dynamic CFS noise ...']);
% waitbar(i/CycleFrames,h);
end
% close(h);

end