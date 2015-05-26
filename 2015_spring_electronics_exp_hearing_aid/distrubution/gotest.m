%  
%                                  _oo8oo_
%                                 o8888888o
%                                 88" . "88
%                                 (| -_- |)
%                                 0\  =  /0
%                               ___/'==='\___
%                             .' \\|     |// '.
%                            / \\|||  :  |||// \
%                           / _||||| -:- |||||_ \
%                          |   | \\\  -  /// |   |
%                          | \_|  ''\---/''  |_/ |
%                          \  .-\__  '-'  __/-.  /
%                        ___'. .'  /--.--\  '. .'___
%                     ."" '<  '.___\_<|>_/___.'  >' "".
%                    | | :  `- \`.:`\ _ /`:.`/ -`  : | |
%                    \  \ `-.   \_ __\ /__ _/   .-` /  /
%                =====`-.____`.___ \_____/ ___.`____.-`=====
%                                  `=---=`
%  
%  
%       ~~~~~~~Powered by https://github.com/ottomao/bugfreejs~~~~~~~
% 
%                          佛祖保佑         永無bug
%            


% [y, fs] = audioread('7b_2764_21947.wav');
[y, fs] = audioread('csNthu.wav');


framesize = 300;
overlap = 60;
framerate = fs/(framesize - overlap);
frameMat=enframe(y, framesize, overlap);	% frame blocking (¤Á¥X­µ®Ø)
frameNum=size(frameMat, 2);			% no. of frames (­µ®Øªº­Ó¼Æ)
volume=frame2volume(frameMat);			% compute volume (­pºâ­µ¶q)
frametime = (0:frameNum-1)/framerate;
% frameMat = frameMat-(zeros(framesize,1)+1)*mean(frameMat);

subplot(2,1,1);

NFFT = 3000;
signal = 20000;
spectrogram(y(:,1),framesize,overlap,NFFT*2,signal);
[s,w,t] = spectrogram(y(:,1),framesize,overlap,NFFT*2,signal*2);
s = fft(frameMat, signal);
s = s([1:6000],:);
subplot(2,1,2);

t = abs(s');
g = geomean(t);
a = mean(t)
e = g./a;
th = 0.5 + abs(min(e([200:6000]))-0.5)/10 ;


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


