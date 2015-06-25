[y, fs, nbit] = wavread('csNthu.wav');
framesize = fs*0.030;
framrate = 50;
hopsize = fs/framrate;
overlap = framesize - hopsize;

sound(y, fs);

% frame analuze
frameMat = enframe(y, framesize, overlap);
frameNum=size(frameMat, 2); %取得# of col
frametime = (0:frameNum-1)/(framrate);
time = (1:length(y))/fs;


volume1=zeros(frameNum, 1); %先將預設音量設為零
volume2=zeros(frameNum, 1); %先將預設音量設為零

% count volume for each frame
for i=1:frameNum
	% method1
	frame = frameMat(:,i);
	frame = frame - median(frame);		% zero-justified
	volume1(i) = sum(abs(frame));             % method 1
	% method2
	frame = frameMat(:,i);
	frame = frame - mean(frame);
	volume2(i) = 10*log10(sum(frame.^2));

end

% ZCR
[minVolume, index]=min(volume1);
shiftAmount=2*max(abs(frameMat(:,index)));	% shiftAmount is equal to twice the max. abs. sample value within the frame of min. volume
method=1;
zcr1=frame2zcr(frameMat, method);
zcr2=frame2zcr(frameMat, method, shiftAmount);
% pitch


subplot(4,1,1);plot(time, y);
% subplot(4,1,2);plot(frametime, volume1);
subplot(4,1,2);plot(frametime, volume2);
subplot(4,1,3);plot(frametime, zcr2);
% subplot(4,1,4);plot(frametime, zcr2);