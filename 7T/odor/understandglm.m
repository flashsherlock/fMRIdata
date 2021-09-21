hrf = [0 0 1 5 8 9.2 9 7 4 2 0 -1 -1 -0.8 -0.7 -0.5 -0.3 -0.1 0];
hrf = hrf / max(hrf);
time = zeros(1, 390);
odor1 = [7 46 59 72 85 124 150 176 215 241 254 280 293 306 332];
odor1time=time;
odor1time(odor1)=1;
odor2 = [20 33 98 111 137 163 189 202 228 267 319 345 358 371 384];
odor2time=time;
odor2time(odor2)=1;
n=2;
voxel=zeros(n,390);
for i=1:n
    % oddvoxel:3-4 even:2-3
    odorhrf=conv(odor1time*(mod(i,2)+2+normrnd(0,0.05))+odor2time*(mod(i,2)+3+normrnd(0,0.05)),hrf);
    odorhrf=odorhrf(1:390);
    % 80% chance response to intensity
    if unifrnd(0,1)>0.2
        inthrf=conv(odor1time*(1.8+normrnd(0,0.05))+odor2time*(2.2+normrnd(0,0.05)),hrf);
    else
        inthrf=conv(odor1time*(1+normrnd(0,0.05))+odor2time*(1+normrnd(0,0.05)),hrf);
    end
    inthrf=inthrf(1:390);
    % 30% chance response to valence
    if unifrnd(0,1)>0.7
        valhrf=conv(odor1time*(1.5+normrnd(0,0.01))+odor2time*(2.5+normrnd(0,0.01)),hrf);
    else
        valhrf=conv(odor1time*(1+normrnd(0,0.01))+odor2time*(1+normrnd(0,0.01)),hrf);
    end
    valhrf=valhrf(1:390);
    % add noise
    noise1=conv(normrnd(0,0.2,[1,390]),hrf);
    noise1=noise1(1:390);
    noise2=normrnd(0,0.5,[1,390]);
    voxel(i,:)=odorhrf+noise1+noise2;
end
plot(voxel')
% regressors
resodor1=conv(odor1time,hrf);
resodor2=conv(odor2time,hrf);
resval=conv(odor1time*1.8+odor2time*2.2,hrf);
resint=conv(odor1time*1.5+odor2time*2.5,hrf);
designmat=[resodor1;resodor2;resval;resint];
designmat=designmat(:,1:390);
plot(designmat')