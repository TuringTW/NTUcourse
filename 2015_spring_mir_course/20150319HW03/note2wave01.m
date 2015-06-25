%% sound: function description
function [outputs] = note2wave01(semi, duration, fs)
	freq = (2.^((semi - 69) ./ 12))*440;
	y = [];
	for	i = 1:length(freq)
		t = (0:(duration(i)*fs))/fs;
		y = [y sin(2*pi*freq(i)*t)];
	end
	outputs = y;
