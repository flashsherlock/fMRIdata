%% Moving-Average Filter
% A moving-average filter is a common method used for smoothing noisy data.
% This example uses the |filter| function to compute averages along a
% vector of data.

%%
% Create a 1-by-100 row vector of sinusoidal data that is corrupted by
% random noise.
t = linspace(-pi,pi,100);
rng default  %initialize random number generator
x = sin(t) + 0.25*rand(size(t));

%%
% A moving-average filter slides a window of length $windowSize$ along
% the data, computing averages of the data contained in each window. The
% following difference equation defines a moving-average filter of a vector $x$:
%%
% 
% $$ y(n)=\frac{1}{windowSize}\left(x(n)+x(n-1)+...+x(n-(windowSize-1))\right). $$
% 

%%
% For a window size of 5, compute the numerator and denominator
% coefficients for the rational transfer function.
windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

%%
% Find the moving average of the data and plot it against the original data.
y = filter(b,a,x);
yy=smooth(x,5);

figure;
plot(t,x)
hold on
plot(t,y)
plot(t,yy)
legend('Input Data','filter','smooth')

%%
%设计低通滤波器：
[N,Wc]=buttord();
%估算得到Butterworth低通滤波器的最小阶数N和3dB截止频率Wc
[a,b]=butter(N,Wc); %设计Butterworth低通滤波器
[h,f]=freqz(); %求数字低通滤波器的频率响应
figure(2); % 打开窗口2
subplot(221); %图形显示分割窗口
plot(f,abs(h)); %绘制Butterworth低通滤波器的幅频响应图
title('巴氏低通滤波器');
grid; %绘制带网格的图像
sf=filter(a,b,s); %叠加函数S经过低通滤波器以后的新函数
subplot(222);
plot(t,sf); %绘制叠加函数S经过低通滤波器以后的时域图形
xlabel('时间 (seconds)');
ylabel('时间按幅度');
SF=fft(sf,256); %对叠加函数S经过低通滤波器以后的新函数进行256点的基—2快速傅立叶变换
w%新信号角频率
subplot(223);
plot(); %绘制叠加函数S经过低通滤波器以后的频谱图
title('低通滤波后的频谱图');
%设计高通滤波器
[N,Wc]=buttord();
%估算得到Butterworth高通滤波器的最小阶数N和3dB截止频率Wc
[a,b]=butter(N,Wc,'high'); %设计Butterworth高通滤波器
[h,f]=freqz(); %求数字高通滤波器的频率响应
figure(3);
subplot(221);
plot(f,abs(h)); %绘制Butterworth高通滤波器的幅频响应图
title('巴氏高通滤波器');
grid; %绘制带网格的图像
sf=filter(); %叠加函数S经过高通滤波器以后的新函数
subplot(222);
plot(t,sf);%绘制叠加函数S经过高通滤波器以后的时域图形
xlabel('Time(seconds)');
ylabel('Time waveform');
w%新信号角频率
subplot(223);
plot(); %绘制叠加函数S经过高通滤波器以后的频谱图
title('高通滤波后的频谱图');
%设计带通滤波器
[N,Wc]=buttord();
%估算得到Butterworth带通滤波器的最小阶数N和3dB截止频率Wc
[a,b]=butter(N,Wc); %设计Butterworth带通滤波器
[h,f]=freqz(); %求数字带通滤波器的频率响应
figure(4);
subplot(221);
plot(f,abs(h)); %绘制Butterworth带通滤波器的幅频响应图
title('butter bandpass filter');
grid; %绘制带网格的图像
sf=filter(a,b,s); %叠加函数S经过带通滤波器以后的新函数
subplot(222);
plot(t,sf); %绘制叠加函数S经过带通滤波器以后的时域图形
xlabel('Time(seconds)');
ylabel('Time waveform');
SF=fft(sf,256); %对叠加函数S经过带通滤波器以后的新函数进行256点的基—2快速傅立叶变换
w%新信号角频率
subplot(223);
plot(); %绘制叠加函数S经过带通滤波器以后的频谱图
title('带通滤波后的频谱图');
