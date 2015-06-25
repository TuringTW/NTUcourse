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
frameSize=epdOpt.frameSize; overlap=epdOpt.overlap;
wave=double(wave);				% convert to double data type (Âà¦¨¸ê®Æ«¬ºA¬O double ªºÅÜ¼Æ)
wave=wave-mean(wave);				% zero-mean substraction (¹sÂI®Õ¥¿)
frameMat=enframe(wave, frameSize, overlap);	% frame blocking (¤Á¥X­µ®Ø)
frameNum=size(frameMat, 2);			% no. of frames (­µ®Øªº­Ó¼Æ)
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


% zcr cross volume
zcrmulti = 1.8;
zcrvol = (zcr>zcrTh + shiftAmount).*zcr.*(volume>volumeTh).*volume/13 + (volume>volumeTh).*volume;
% zcr 1.6 vol 0.11
% 14 63.33
% 13 63.47
% 12 63.33
% 11 63.33


sorting = sort(zcrvol(zcrvol>0));
sortsize = length(sorting);
zvl = sorting(ceil(sortsize*0.03));
zvu = sorting(floor(sortsize*0.97));
zvTh = (zvu - zvl)*0.09 +zvl;


% zcr 1.6 vol 0.11 /13
% 0.08 63.19
% 0.09 63.47
% 0.10 63.33
% 0.11 63.19

% find index
% index=find(volume>=volumeTh|zcr>=zcrTh + shiftAmount);		% find frames with volume larger than the threshold (§ä¥X¶W¹L­µ¶qªùÂe­Èªº­µ®Ø)
initindex=find(zcrvol == max(zcrvol), 1);		% find frames with volume larger than the threshold (§ä¥X¶W¹L­µ¶qªùÂe­Èªº­µ®Ø)

% find front zero
frontzv = zcrvol(1:initindex);
temp = find((frontzv(1:end-2)==0).*(frontzv(2:end-1)==0).*(frontzv(3:end)==0));%output index of 0
if(isempty(temp))
	sindex = initindex;%如果是0舊輸出原本的
else
	sindex = temp(end);
end

% find front zero
backzv = zcrvol(initindex:end);
temp = find((backzv(1:end-2)==0).*(backzv(2:end-1)==0).*(backzv(3:end)==0));%output index of 0
if(isempty(temp))
	eindex = initindex;%如果是0舊輸出原本的
else
	eindex = initindex + temp(1) - 1;
end


epInFrameIndex=[sindex, eindex];
epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);	% conversion from frame index to sample index (¥Ñ frame index Âà¦¨ sample index)

if showPlot,
	subplot(2,1,1);
	time=(1:length(wave))/fs;
	plot(time, wave); axis tight;
	line(time(epInSampleIndex(1))*[1 1], [min(wave), max(wave)], 'color', 'g');
	line(time(epInSampleIndex(end))*[1 1], [min(wave), max(wave)], 'color', 'm');
	



	ylabel('Amplitude'); title('Waveform');

	subplot(2,1,2);
	frameTime=((1:frameNum)-1)*(frameSize-overlap)+frameSize/2;
	plot(frameTime, volume, frameTime, zcr.*zcrmulti, frameTime, zcrvol, '.-'); axis tight;
	line([min(frameTime), max(frameTime)], volumeTh*[1 1], 'color', 'r');
	line(frameTime(epInFrameIndex(1))*[1 1], [0, max(volume)], 'color', 'g');
	line(frameTime(epInFrameIndex(end))*[1 1], [0, max(volume)], 'color', 'm');
	line(frameTime(initindex(1))*[1 1], [0, max(volume)], 'color', 'b');
	line(frameTime(initindex(end))*[1 1], [0, max(volume)], 'color', 'r');
	
	line([min(frameTime), max(frameTime)], (zcrTh + shiftAmount)*[1 1].*zcrmulti, 'color', 'b');
	line([min(frameTime), max(frameTime)], zvTh*[1 1], 'color', 'y');

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
