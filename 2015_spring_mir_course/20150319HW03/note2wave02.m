%% sound: function description
function [outputs] = note2wave02(semi, duration, fs)
	freq = (2.^((semi - 69) ./ 12))*440;
	phi = [0];
	for	i = 1:length(freq)
		t = (0:(duration(i)*fs))/fs;
		phi = [phi 2*pi*freq(i)*t+phi(end)];
	end
	outputs = sin(phi(2:end));
