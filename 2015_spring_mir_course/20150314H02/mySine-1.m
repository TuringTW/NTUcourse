% [y, fs] = audioread('uraman.mp3');
%% mySine: function description
function [outputs] = mySine(duration, freq)
	fs = 16000;
	time = (0:duration*fs-1);
	if freq(1) <= freq(2)
		mfreq = (freq(1)+time*(freq(2)-freq(1))/(duration*fs-1));
		y = sin((mfreq*2*pi).*(time/fs));
	else
		mfreq = (freq(2)+time*(freq(1)-freq(2))/(duration*fs-1));
		y = fliplr(sin((mfreq*2*pi).*(time/fs)));
	end
		
	% plot(time/fs, (mfreq*2*pi).*(time/fs), time/fs, y, time/fs, (time/fs))
	outputs = y;
	% sound(y, fs)
end


