%% freqamp: function description
function [outputs] = freqamp(freq, ratio)
	duration = 2;
	fs = 44100;
	time = (0:duration*fs-1)/fs;
	if ratio<=1
		y(:, 1) = 0.1*sin(2*pi*1000.*time).*(sin(2*pi.*time*0.8)).^2+ratio*sin(2*pi*freq.*time).*(cos(2*pi.*time*0.8).^2);
		y(:, 2) = 0*sin(2*pi*1000.*time).*(sin(2*pi.*time*0.8)).^2;
		sound(y,fs);
		
		check = input('which one is louder? z for fixed, c for variable, x for equal:','s');

		switch check
			case 'z'
				result = freqamp(freq, ratio/0.8);
				outputs = result;
			case 'x'
				outputs = ratio;
			case 'c'
				result = freqamp(freq, ratio*0.8);
				outputs = result;
			otherwise
				result = freqamp(freq, ratio*1);
				outputs = result;
		end
	else
		outputs = ratio;
	end
		
	
