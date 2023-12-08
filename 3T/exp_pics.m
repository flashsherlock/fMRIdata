datafolder='/Volumes/WD_D/allsub/fMRI/fMRI/';
GreenInt=0.6;
BlueInt=0.6;
for i=[2 6 13 18]
    GreyFearfulFace=imread([datafolder int2str(i) '.jpg']);
    GreenFearfulFace=zeros(size(GreyFearfulFace));
    GreenFearfulFace(:,:,2)=GreyFearfulFace(:,:,2)*GreenInt;
    GreenFearfulFace(:,:,3)=GreyFearfulFace(:,:,3)*BlueInt;
    imwrite(GreenFearfulFace/255,[datafolder int2str(i) '_gb.jpg'])
end
StimSizeNoise=[0 0 260 260];
NoiseSize=4; % The number is bigger, the size is smaller.
NoiseNum=200; % How many squares rectangles in a noise frame
CycleFrames=100; % How many noise frames
NoiseColor=1;
w=GenerateDynamicCFS_UMNVAL(StimSizeNoise(3), StimSizeNoise(4), CycleFrames, NoiseNum, NoiseSize, NoiseColor);
imwrite(w(:,:,:,1)/255,[datafolder 'noise.bmp'])