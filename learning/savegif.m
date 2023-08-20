function savegif(filename,n,delay)
if nargin<3
    delay=0.1;
end
if nargin<2
    n=2;
end
frame = getframe(gcf);
im = frame2im(frame);
[A,map] = rgb2ind(im,256); 
if n == 1
    imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay);
else
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay);
end