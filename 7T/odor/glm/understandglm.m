% set seed
rng(666);
% hrf function
hrf = [0 0 1 5 8 9.2 9 7 4 2 0 -1 -1 -0.8 -0.7 -0.5 -0.3 -0.1 0];
hrf = hrf / max(hrf);
% seconds and odor time points
seconds = 390*5;
points = 7:13:seconds;
odornum = 5;
odorspoints = reshape(randperm(length(points)),odornum,[]);
odorspoints = points(odorspoints);
% set response
% real = [6 4 5 15 13];
real = [5 5 5 5 5];
val = [4.8 4.5 1.5 3.8 3.2];
int = [2.2 1.8 3.4 3.6 3.2];
% set time points with odor to 1
odors = zeros(odornum, seconds);
key = odors;
for i=1:odornum
    odors(i,odorspoints(i,:))=1;
    key(i,odorspoints(i,:)+6+round(normrnd(0,0.3,[1,size(odorspoints,2)])))=1;
end
% generate voxels
n=100;
voxel=zeros(n,seconds);
vires=zeros(n,2);% 1-valence 2-intensity
for i=1:n
    % oddvoxel:3 5 4 2 4 even:2-3
%     realres = mod(i,n)/n*real+normrnd(0,0.05,1,odornum)+mod(i,n)/n;
    realres = real+normrnd(0,0.05,1,odornum)+mod(i,2);
    odorhrf=conv(realres*odors,hrf);
    odorhrf=odorhrf(1:seconds);
    % 30% chance response to valence
    valres = val+normrnd(0,0.02,1,odornum);
    if unifrnd(0,1)>0.7
        vires(i,1) = 1;
        valhrf=conv(valres*odors,hrf);
    else
        valhrf=conv((ones(1,odornum)+normrnd(0,0.02,1,odornum))*odors,hrf);
    end
    valhrf=valhrf(1:seconds);
    % 80% chance response to intensity
    intres = int+normrnd(0,0.05,1,odornum);
    if unifrnd(0,1)>0.2
        vires(i,2) = 1;
        inthrf=conv(intres*odors,hrf);
    else
        inthrf=conv((ones(1,odornum)+normrnd(0,0.05,1,odornum))*odors,hrf);
    end
    inthrf=inthrf(1:seconds);
    % add noise
    noise1=conv(normrnd(0,0.2,[1,seconds]),hrf);
    noise1=noise1(1:seconds);
    noise2=normrnd(0,0.5,[1,seconds]);
    voxel(i,:)=odorhrf+inthrf+valhrf+noise1+noise2;
end
% figure
% plot(voxel')
% regressors
resodor = zeros(size(odors));
for i=1:odornum
    temp=conv(odors(i,:)+normrnd(0,0.01,1,seconds),hrf);
    temp=temp(1:seconds);
    resodor(i,:)=temp;
end
reskey=conv(sum(key),hrf);
resval=conv(val*odors,hrf);
resint=conv(int*odors,hrf);
% resint=conv([1.8 2.2 2 1.9 2.1]*odors,hrf);
designmat=[resval;resint;reskey];
designmat=designmat(:,1:seconds);
% odor regressor
% designmat=[resodor;designmat];
% ones regressor
% resone = conv(sum(odors),hrf);
% resone=resone(1:seconds);
% designmat=[resone;designmat];
% plot regressors
figure
nplots = size(designmat,1);
for i=1:nplots
    subplot(2,round(nplots/2),i)
    plot(designmat(i,:)')
end
% glm fit
voxelfit=zeros(n,seconds);
% the constant term is the first element of b
b=zeros(size(designmat,1)+1,n);
wholemat=[ones(seconds,1) designmat'];
% wholemat=[ones(seconds,1) designmat([6 7 8],:)'];
fits=zeros(size(voxel));
for i=1:n
    b(:,i)=glmfit(designmat',voxel(i,:));
    val=wholemat*b(:,i);
%     val=wholemat*b([1 7:9],i);
    fits(i,:)=val';    
end
errors=voxel-fits;
% figure
% plot(fits')
% figure
% plot(errors')
% get 6s response
maxrespoints = sort(odorspoints,2)+6;
maxres = zeros(odornum,size(odorspoints,2),n);
maxfit = maxres;
for i=1:n
    i_errors = errors(i,:);
    maxres(:,:,i) = i_errors(maxrespoints);
    i_fits = fits(i,:);
    maxfit(:,:,i) = i_fits(maxrespoints);
end
mean_res=squeeze(mean(maxres,2));
mean_fit=squeeze(mean(maxfit,2));
% RSA
maxres_re=reshape(permute(maxres,[2,1,3]),150,n);
rho=corr(maxres_re');
figure
imagesc(1-rho);
colormap jet
colorbar
% MVPA
passed_data.data=maxres_re;
results=decoding_roi_5odors_glm(passed_data);
disp(results.confusion_matrix.output{1});