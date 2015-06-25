function [epInSampleIndex, epInFrameIndex] = myEpd(au, epdOpt, showPlot)
% myEpd: a simple example of EPD
%
%	Usage:
%		[epInSampleIndex, epInFrameIndex] = endPointDetect(au, showPlot, epdOpt)
%			epInSampleIndex: two-element end-points in sample index
%			epInFrameIndex: two-element end-points in frame index
%			au: input wave object
%			epdOpt: parameters for EPD
%			showPlot: 0 for silence operation, 1 for plotting
%
%	Example:
%		waveFile='SingaporeIsAFinePlace.wav';
%		au=waveFile2obj(waveFile);
%		epdOpt=myEpdOptSet;
%		showPlot = 1;
%		out = myEpd(au, epdOpt, showPlot);

%	Roger Jang, 20040413, 20070320, 20130329

if nargin<1, selfdemo; return; end
if nargin<2, epdOpt=myEpdOptSet; end
if nargin<3, showPlot=0; end

wave=au.signal; fs=au.fs;
frameSize=epdOpt.frameSize; 
overlap=epdOpt.overlap;
wave=double(wave);				% convert to double data type (轉成資料型態是 double 的變數)
% wave=wave-mean(wave);				% zero-mean substraction (零點校正)
frameMat=enframe(wave, frameSize, overlap);	% frame blocking (切出音框)
frameMat=frameMat([8:end],:);
frameSize = frameSize-7;
frameNum=size(frameMat, 2);			% no. of frames (音框的個數)
% volume=frame2volume(frameMat);			% compute volume (計算音量)
% volumeTh=max(volume)*epdOpt.volumeRatio;	% compute volume threshold (計算音量門檻值)





% fft
% frameMat = frameMat-(zeros(frameSize,1)+1)*mean(frameMat);
signal = 12000;
s = fft(frameMat, signal);

% noise cancel
t = abs(s');
g = geomean(t);
a = mean(t);
e = g./a;
% th = 0.5 + abs(min(e([200:6000]))-0.5)*1.03;
minth = min(e([100:signal/2]));
maxth = max(e([100:signal/2]));
meanth = mean(e([100:signal/2]));
th = minth + (maxth-minth)*(meanth/2+0.5)*0.97;
index = [1:signal];
% 10 68.9
% 50 68.9
% 100 68.9
delf = find(e>th);
s([delf],:)=0;
% index(delf)=[];

s = s.*(log2(index')*zeros(1,frameNum)+1); 
% 0.07 88.19
% 0.06 88.19
% 0.05 87.50
% fftc = zcr.*1 + max(abs(s).*(1+log(index'*(zeros(1,size(s,2))+50))));

% sorting = sort(fftc);
% sortsize = length(sorting);
% fl = sorting(ceil(sortsize*0.03));
% fu = sorting(floor(sortsize*0.97));
% fftTh = (fu - fl)*0.015 +fl;
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

frameMat = ifft(s, frameSize, 'nonsymmetric');

volume=frame2volume(frameMat);			% compute volume (計算音量)

[minVolume, index]=min(volume);
initvolTh = max(abs(frameMat(:,index)));
% zcr 
shiftAmount=2*initvolTh;	% shiftAmount is equal to twice the max. abs. sample value within the frame of min. volume
method=1;
zcr1 = frame2zcr(frameMat, method, shiftAmount);

sorting = sort(zcr1);
zl = sorting(ceil(frameNum*0.3));
zu = sorting(floor(frameNum*0.97));
zcrTh = (zu - zl)*exp(-(zu - zl)*0.17) +zl;

zcr = (zcr1>zcrTh).*zcr1;



% find index
% index=find(volume>=volumeTh|zcr>=zcrTh + shiftAmount);		% find frames with volume larger than the threshold (找出超過音量門檻值的音框)
initindex=find(zcr==max(zcr));		% find frames with volume larger than the threshold (找出超過音量門檻值的音框)
% find front zero
frontf = zcr(1:initindex(1));
temp = find(frontf==0);
if(isempty(temp))
	sindex = initindex(1);
else
	sindex = temp(end);
	if(length(temp)>=7)
		temp = find((frontf(1:end-6)==0).*(frontf(2:end-5)==0).*(frontf(3:end-4)==0).*(frontf(4:end-3)==0).*(frontf(5:end-2)==0).*(frontf(6:end-1)==0).*(frontf(7:end)==0)==1);
		if(~isempty(temp))
			sindex = temp(end)+6;
		end
	end
end
backf = zcr(initindex(end):end);
temp = find(backf==0);
if(isempty(temp))
	eindex = initindex(end);
else
	eindex = initindex(end) + temp(1) - 1;

	if(length(temp)>=7)
		temp = find((backf(1:end-2)==0).*(backf(2:end-1)==0).*(backf(3:end-0)==0)==1);
		if(~isempty(temp))
			eindex = initindex(end) + temp(1) - 1;
		end
	end
end

epInFrameIndex=[sindex, eindex];
epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);	% conversion from frame index to sample index (由 frame index 轉成 sample index)

if showPlot,
	subplot(2,1,1);
	time=(1:length(wave))/fs;
	plot(time, wave); axis tight;
	line(time(epInSampleIndex(1))*[1 1], [min(wave), max(wave)], 'color', 'g');
	line(time(epInSampleIndex(end))*[1 1], [min(wave), max(wave)], 'color', 'm');
	



	ylabel('Amplitude'); title('Waveform');

	subplot(2,1,2);
	frameTime=((1:frameNum)-1)/(fs/(frameSize-overlap));
	% frameTime=((1:frameNum)-1)*(frameSize-overlap)+frameSize/2;
	plot(frameTime, zcr1,frameTime, zcr, '.-'); axis tight;
	line(frameTime(epInFrameIndex(1))*[1 1], [0, max(zcr)], 'color', 'g');
	line(frameTime(epInFrameIndex(end))*[1 1], [0, max(zcr)], 'color', 'm');
	line(frameTime(initindex(1))*[1 1], [0, max(zcr)], 'color', 'b');
	line(frameTime(initindex(end))*[1 1], [0, max(zcr)], 'color', 'r');
	
	% line([min(frameTime), max(frameTime)], (fftTh)*[1 1], 'color', 'b');
	line([min(frameTime), max(frameTime)], (zcrTh)*[1 1], 'color', 'r');

	ylabel('Sum of abs.'); title('Volume');

	U.wave=wave; U.fs=fs;
	if ~isempty(epInSampleIndex)
		U.voicedY=U.wave(epInSampleIndex(1):epInSampleIndex(end));
	else
		U.voicedY=[];
	end
	set(gcf, 'userData', U);
	uicontrol('string', 'Play all', 'callback', 'U=get(gcf, ''userData''); sound(U.wave, U.fs);', 'position', [20, 20, 100, 20]);
	uicontrol('string', 'Play detected', 'callback', 'U=get(gcf, ''userData''); sound(U.voicedY, U.fs);', 'position', [150, 20, 100, 20]);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
