fs=16000;	% 取樣頻率
nBits=16;		% 取樣點解析度，必須是 8 或 16 或 24
nChannel=1;	% 聲道個數，必須是1(單聲道)或2(雙聲道或立體音)
duration=0.1;	% 錄音時間（秒）
recObj = audiorecorder(fs,nBits,nChannel,1); 
while 1
	
	record(recObj);
	pause(duration)
	stop(recObj);
	y = getaudiodata(recObj, 'double');	% get data as a double arrayyy

	plot((1:length(y))/fs, y);
	xlabel('Time (sec)'); ylabel('Amplitude');

	sound(y, fs);

end

% SAP toolbox老師血的函式庫

