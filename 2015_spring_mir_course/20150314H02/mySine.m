% [y, fs] = audioread('uraman.mp3');
%% mySine: function description
function [outputs] = mySine(duration, freq)
	fs = 16000;
	time = (0:duration*fs-1)/fs;
	m = (freq(2) - freq(1))/((duration*fs-1)/fs);
	phi = (freq(1) * time +  0.5 * m * (time.*time) );
	y = sin(2*pi*phi);

	% plot( time/fs, y)
	outputs = y;
	% sound(y, fs)
end


