%% myEncrypt: function description
function  myEncrypt(inputfilename, outputfilename)
	[y, fs] = wavread(inputfilename);
	info = audioinfo(inputfilename);

	z = y;
	for i = 1:length(y)
		if y(i)>0
			z(i) = 1 - y(i);
		elseif y(i)<0
			z(i) = -1 - y(i);
		end
	end
	z = flipud(z);
	wavwrite(z, fs, info.BitsPerSample, outputfilename);
end
