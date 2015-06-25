% [y, fs] = audioread('Sa_6976_14784.wav');
[y, fs] = audioread('0a_4864_18815.wav');


frameSize = 300;
overlap = 60;
framerate = fs/(frameSize - overlap);
frameMat=enframe(y, frameSize, overlap);	% frame blocking (¤Á¥X­µ®Ø)
frameNum=size(frameMat, 2);			% no. of frames (­µ®Øªº­Ó¼Æ)
volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)
frametime = (0:frameNum-1)/framerate;
% frameMat = frameMat-(zeros(framesize,1)+1)*mean(frameMat);

frameMat=frameMat([8:end],:);
frameSize = frameSize-7;
frameNum=size(frameMat, 2);			% no. of frames (­µ®Øªº­Ó¼Æ)
% volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)
% volumeTh=max(volume)*epdOpt.volumeRatio;	% compute volume threshold (­pºâ­µ¶qªùÂe­È)


% fft
frameMat = frameMat-(zeros(frameSize,1)+1)*mean(frameMat);
signal = 12000;
s = fft(frameMat, signal);

% noise cancel
t = abs(s');
g = geomean(t);
a = mean(t);
e = g./a;
% th = 0.3; 
% + abs(min(e([200:6000]))-0.5)*1.03;
th = min(e([50:signal/2]))+0.12;
index = [1:signal];
% 10 68.9
% 50 68.9
% 100 68.9
delf = find(e>=th)
s([delf],:)=0;
% index(delf)=[];
% 0.07 88.19
% 0.06 88.19
% 0.05 87.50
frameMat1 = ifft(s, frameSize, 'nonsymmetric');

volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)

[minVolume, index]=min(volume);
initvolTh = max(abs(frameMat(:,index)));
% zcr 
shiftAmount=2*initvolTh;	% shiftAmount is equal to twice the max. abs. sample value within the frame of min. volume
method=1;
zcr = frame2zcr(frameMat, method, shiftAmount);



% ===========================
% fftc = zcr*0 + max(abs(s).*(1+log(index'*(zeros(1,size(s,2))+50))));

% sorting = sort(fftc);
% sortsize = length(sorting);
% fl = sorting(ceil(sortsize*0.03));
% fu = sorting(floor(sortsize*0.97));
% fftTh = (fu - fl)*0.021 +fl;
% ==============================
% 0.02 93.06
% 0.015 93.06
% 0.013 93.75
% 0.012 94.44
% 0.0115 95.14
% 0.011 95.14
% 0.01 94.44
% 0.009 94.44
% 0.008 94.44
% 0.007 93.06
% 0.005 91.67


% 0.02  40.10 
% 0.03  41.84
% 0.04  42.19
% 0.05  43.23
% 0.055 42.88
% 0.06  42.71


% =======================

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
	if(length(temp)>=2)
		temp = find((frontf(1:end-1)==0).*(frontf(2:end)==0)==1);
		if(~isempty(temp))
			sindex = temp(end)+1;
		end
	end
end
backf = fftc2(initindex(end):end);
temp = find(backf==0);
if(isempty(temp))
	eindex = initindex(end);
else
	eindex = initindex(end) + temp(1) - 1;

	if(length(temp)>=2)
		temp = find((backf(1:end-1)==0).*(backf(2:end)==0)==1);
		if(~isempty(temp))
			eindex = initindex(end) + temp(1) - 1;
		end
	end
end

epInFrameIndex=[sindex, eindex];
epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);	% conversion from frame index to sample index (¥Ñ frame index Âà¦¨ sample index)


subplot(2,2,1);
time=(1:length(y))/fs;
plot(time, y); axis tight;
line(time(epInSampleIndex(1))*[1 1], [min(y), max(y)], 'color', 'g');
line(time(epInSampleIndex(end))*[1 1], [min(y), max(y)], 'color', 'm');




ylabel('Amplitude'); title('yform');

subplot(2,2,3);
frameTime=((1:frameNum)-1)/(fs/(frameSize-overlap));
% frameTime=((1:frameNum)-1)*(frameSize-overlap)+frameSize/2;
plot(frameTime,zcr,  '.-'); axis tight;
line(frameTime(epInFrameIndex(1))*[1 1], [0, max(fftc2)], 'color', 'g');
line(frameTime(epInFrameIndex(end))*[1 1], [0, max(fftc2)], 'color', 'm');
line(frameTime(initindex(1))*[1 1], [0, max(fftc2)], 'color', 'b');
line(frameTime(initindex(end))*[1 1], [0, max(fftc2)], 'color', 'r');

line([min(frameTime), max(frameTime)], (fftTh)*[1 1], 'color', 'b');

ylabel('Sum of abs.'); title('Volume');

U.y=y; U.fs=fs;
if ~isempty(epInSampleIndex)
	U.voicedY=U.y(epInSampleIndex(1):epInSampleIndex(end));
else
	U.voicedY=[];
end
set(gcf, 'userData', U);
uicontrol('string', 'Play all', 'callback', 'U=get(gcf, ''userData''); sound(U.y, U.fs);', 'position', [20, 20, 100, 20]);
uicontrol('string', 'Play detected', 'callback', 'U=get(gcf, ''userData''); sound(U.voicedY, U.fs);', 'position', [150, 20, 100, 20]);


subplot(2,2,2);
temp = frameMat1((1:(frameSize-overlap)),(1:frameNum));
y1 = reshape(temp,1,size(temp,1)*size(temp,2));
time = (1:length(y1))/fs;
plot(time, y1);

NFFT = 1000;
signal = 12000;
% spectrogram(y(:,1),frameSize,overlap,NFFT*2,12000);
[s,w,t] = spectrogram(y(:,1),frameSize,overlap,NFFT*2,signal*2);
s = fft(frameMat, signal);
s = s([1:6000],:);
subplot(2,2,4);


volume1=frame2volume(frameMat1);			% compute volume (­pºâ­µ¶q)

[minVolume, index]=min(volume1);
initvolTh = max(abs(frameMat1(:,index)));
% zcr 
shiftAmount=2*initvolTh;	% shiftAmount is equal to twice the max. abs. sample value within the frame of min. volume
method=1;
zcr1 = frame2zcr(frameMat1, method, shiftAmount);



plot(frameTime,zcr1,  '.-'); axis tight;


% plot([1:6000], e(1:6000)); axis tight;
% line([1,6000], th*[1 1], 'color', 'g');