function degree =vangle( distance,size,resolution,pixel )
%compute the visual angle
%input the distance to the screen(meter),the diagonal size of the screen
%(meter),the resolution of the screen([width height]),pixel size of the 
%stimuli,then you can get the visual angel of the stimuli.
%每个像素的大小
d=sin(atan(resolution(1)/resolution(2)))*size/resolution(1);
%计算视角
degree=2*atand(pixel*d/2/distance);
end

