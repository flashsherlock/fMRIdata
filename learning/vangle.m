function degree =vangle( distance,size,resolution,pixel )
%compute the visual angle
%input the distance to the screen(meter),the diagonal size of the screen
%(meter),the resolution of the screen([width height]),pixel size of the 
%stimuli,then you can get the visual angel of the stimuli.
%ÿ�����صĴ�С
d=sin(atan(resolution(1)/resolution(2)))*size/resolution(1);
%�����ӽ�
degree=2*atand(pixel*d/2/distance);
end

