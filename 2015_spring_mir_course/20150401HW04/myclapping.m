% [y, fs] = audioread('fastestclap.mp3');
% 自己的
[y, fs] = audioread('myclap.wav');
y = y(:, 1); %選擇第一軌
time = (0:length(y)-1)/fs;
% frame setting
framesize = fs*0.030;
framrate = 70;
hopsize = fs/framrate;
overlap = framesize - hopsize;
% frame analuze
frameMat = enframe(y, framesize, overlap);
frameNum=size(frameMat, 2); %取得# of col
frametime = (0:frameNum-1)/(framrate);
time = (0:length(y)-1)/fs;

volume1=zeros(frameNum, 1); %先將預設音量設為零
% count volume for each frame
for i=1:frameNum
	% method1
	frame = frameMat(:,i);
	frame = frame - median(frame);		% zero-justified
	volume1(i) = sum(abs(frame));             % method 1
end
index = local_max(volume1.*(volume1>20));
rate = 13 * framrate ./ (index(14:end) - index(1:end-13));

% framecut
first = local_max(rate);
firsts = index(first(1));
firste = index(first(1)+13);

% plot
subplot(4,1,1);plot(time, y);
subplot(4,1,2);plot(frametime, volume1);
hold on;
plot([frametime(firsts), frametime(firsts)],[0, 600]);
plot([frametime(firste), frametime(firste)],[0, 600]);
% subplot(4,1,3);plot(frametime, volume2);
% subplot(4,1,3);plot(frametime, zcr2);
subplot(4,1,3);
% hold on;
plot(frametime(index(1:end-13)), rate);
% plot(frametime(index(1:end-13)), zeros(size(index, 1)-13, 1)+14);
% plot(frametime(index(1:end-13)), zeros(size(index, 1)-13, 1)+13);
% plot([frametime(firsts), frametime(firsts)],[0, 20]);
% plot([frametime(firste), frametime(firste)],[0, 20]);

subplot(4,1,4);plot(frametime(firsts-1:firste+1), volume1(firsts-1:firste+1));
hold on;
plot([frametime(firsts), frametime(firsts)],[0, 600]);
plot([frametime(firste), frametime(firste)],[0, 600]);