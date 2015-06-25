% [y, fs] = audioread('Zb_13818_20957.wav');
[y, fs] = audioread('6a_5888_15104.wav');


framesize = 300;
overlap = 60;
framerate = fs/(framesize - overlap);
frameMat=enframe(y, framesize, overlap);	% frame blocking (¤Á¥X­µ®Ø)
frameNum=size(frameMat, 2);			% no. of frames (­µ®Øªº­Ó¼Æ)
volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)
frametime = (0:frameNum-1)/framerate;
frameMat = frameMat-(zeros(framesize,1)+1)*mean(frameMat);

subplot(1,2,1);

NFFT = 600;
signal = 12000;
spectrogram(y(:,1),framesize,overlap,NFFT*2,6000);
[s,w,t] = spectrogram(y(:,1),framesize,overlap,NFFT*2,signal*2);
s = fft(frameMat, signal);
f200 = s(200,:);
f400 = s(400,:);
f600 = s(600,:);
f800 = s(800,:);
f1000 = s(1000,:);
f1200 = s(1200,:);

s = abs(s([300:end],:));
sums = sum(s);
temp = (zeros(size(s, 1),1)+1)*sums;
p = s ./ temp;
e = -sum(log(p).*p);
subplot(1,2,2);
plot(e, frametime, f200, frametime,f400, frametime,f600, frametime,f800, frametime,f1000, frametime,f1200, frametime);

