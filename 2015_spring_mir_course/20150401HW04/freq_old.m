% [y, fs] = audioread('7b_2764_21947.wav');
[y, fs] = audioread('6a_6291_16979.wav');


framesize = 300;
overlap = 60;
framerate = fs/(framesize - overlap);
frameMat=enframe(y, framesize, overlap);	% frame blocking (¤Á¥X­µ®Ø)
frameNum=size(frameMat, 2);			% no. of frames (­µ®Øªº­Ó¼Æ)
volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)
frametime = (0:frameNum-1)/framerate;
% frameMat = frameMat-(zeros(framesize,1)+1)*mean(frameMat);

subplot(2,3,1);

NFFT = 1000;
signal = 12000;
spectrogram(y(:,1),framesize,overlap,NFFT*2,12000);
[s,w,t] = spectrogram(y(:,1),framesize,overlap,NFFT*2,signal*2);
s = fft(frameMat, signal);
s = s([1:6000],:);
subplot(2,3,4);

t = abs(s');
g = geomean(t);
a = mean(t)
e = g./a;
th = 0.5 + abs(min(e([200:6000]))-0.5)/10 ;

delf = find(e>th);
indexf = [1:signal/2];
indexf([delf])=[];
s([delf],:)=[];
f1200 = s;

plot([1:6000], e);




% plot(e, frametime, f200, frametime,f400, frametime,f600, frametime,f800, frametime,f1000, frametime,f1200, frametime);
volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)
% volumeTh=max(volume)*epdOpt.volumeRatio;	% compute volume threshold (­pºâ­µ¶qªùÂe­È)
[minVolume, index]=min(volume);
initvolTh = max(abs(frameMat(:,index)));
sorting = sort(volume(volume>initvolTh*2));
sortsize = length(sorting);
vl = sorting(ceil(sortsize*0.03));
vu = sorting(floor(sortsize*0.97));
volumeTh = (vu - vl)*0.11 +vl;
% zcr=1.2 zv=0.09
% 0.15 55.42%
% 0.13 58.33%
% 0.11 62.22%
% 0.10 63.89%
% 0.09 63.75%
% 0.08 63.47%
% 0.07 62.92%
% 0.06 61.81%

% zcr 
shiftAmount=4*initvolTh;	% shiftAmount is equal to twice the max. abs. sample value within the frame of min. volume
method=1;
zcr = frame2zcr(frameMat, method, shiftAmount);
% zcrTH = max(zcr)*epdOpt.zcrRatio;
sorting = sort(zcr);
zl = sorting(ceil(frameNum*0.1));
zu = sorting(floor(frameNum*0.9));
zcrTh = (zu - zl)*1.6 +zl;
% vth 0.11 zcr*vol/12+vol
% 1.8 63.33
% 1.7 63.33
% 1.6 63.33
% 1.5 63.19
% 1.4 62.78
% 1.3 62.42
% 1.2 62.22
% 1.1 62.08
% 1.0 61.67

fftc = max(abs(s).*(indexf'*(zeros(1,size(s,2))+1)));
sorting = sort(fftc);
sortsize = length(sorting);
fl = sorting(ceil(sortsize*0.03));
fu = sorting(floor(sortsize*0.97));
fftTh = (fu - fl)*0.011 +fl;

fftc2 = fftc.*(fftc>fftTh);



% find index
% index=find(volume>=volumeTh|zcr>=zcrTh + shiftAmount);		% find frames with volume larger than the threshold (§ä¥X¶W¹L­µ¶qªùÂe­Èªº­µ®Ø)
initindex=find(fftc2==max(fftc2));		% find frames with volume larger than the threshold (§ä¥X¶W¹L­µ¶qªùÂe­Èªº­µ®Ø)
% find front zero
frontf = fftc2(1:initindex(1));
temp = find(frontf==0);
if(isempty(temp))
	sindex = initindex(1);
else
	sindex = temp(end);
end
backf = fftc2(initindex(end):end);
temp = find(backf==0);
if(isempty(temp))
	eindex = initindex(end);
else
	eindex = initindex(end) + temp(1) - 1;
end
subplot(1,3,3);
epInFrameIndex=[sindex, eindex];
epInSampleIndex=frame2sampleIndex(epInFrameIndex, framesize, overlap);	% conversion from frame index to sample index (¥Ñ frame index Âà¦¨ sample index)
line( [0, max(fftc2)],frametime(epInFrameIndex(1))*[1 1], 'color', 'g');
line( [0, max(fftc2)],frametime(epInFrameIndex(end))*[1 1], 'color', 'm');
line( [0, max(fftc2)],frametime(initindex(1))*[1 1], 'color', 'b');
line( [0, max(fftc2)],frametime(initindex(end))*[1 1], 'color', 'r');

line((fftTh)*[1 1],[min(frametime), max(frametime)],  'color', 'b');



plot( fftc, frametime, volume*100, frametime,zcr*300, frametime);

subplot(2,3,2);
time = (0:length(y)-1)/fs;
plot(y,time);