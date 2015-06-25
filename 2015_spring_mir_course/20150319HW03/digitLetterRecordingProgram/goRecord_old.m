% 對數字進行錄音，共要錄兩次，用以檢測 speaker-dependent DTW 的效能
% Roger Jang, 20020328, 20050314

% ====== 檢查 MATLAB 版本
desiredVersion='6.5';
matlabVersion=version;
if ~strcmp(matlabVersion(1:3), desiredVersion)
	fprintf('建議使用版本：%s\n', desiredVersion);
end

% ====== 錄音參數
duration = 2;
fs = 16000;
%nbits = 8; format = 'uint8';		% 8-bit
nbits = 16; format = 'int16';		% 16-bit
waveDir = '../waveFile';

if exist(waveDir, 'dir') ~= 7,
	fprintf('Making wave directory => %s\n', waveDir);
	mkdir(waveDir);
end

validInput=0;
while ~validInput
	name = input('請輸入您的「學號」加「姓名」（例如：921510張智星）：', 's');
%	validName = name(find(name>=double('一')));		% 保留中文：國字的「一」是最短筆劃的字
	validName = name(find(name>=double('0')));		% 保留中英文和數字
	if length(validName)>=2, validInput=1; end
end
userDir = [waveDir, '/', validName]; 
if exist(userDir, 'dir') ~= 7,
	fprintf('Making personal wave directory => %s\n', userDir);
	mkdir(userDir);
end

% ====== 找出所有的數字
allDigit = textread('digitLetter.txt', '%s', 'delimiter', '\n', 'whitespace', '');
% ====== 找出已錄音的檔案
dirInfo = dir(waveDir);
deleteIndex = [];

for i=3:length(dirInfo)
	userDirtemp=[waveDir, '/',(dirInfo(i).name)];
	currentWaveFile = dir([userDirtemp, '\*.wav']); 

	for i=1:length(currentWaveFile),
		digit = currentWaveFile(i).name(1:end-4);
		index = strmatch(digit, allDigit, 'exact');
		if ~isempty(index),
			deleteIndex = [deleteIndex; index];
		end
	end
  
end

% ====== 跳過已錄音的歌名
allDigit(deleteIndex) = [];
digitNum = length(allDigit);
if ~isempty(deleteIndex),
	fprintf('已有 %g 個錄音檔案。\n', length(deleteIndex));
end

% ======  Load "waverecord"
wavrecord(0.1*fs, fs, 'uint8');

for i=1:digitNum,
	waveFile = [userDir, '/',allDigit{i}, '.wav'];
	displayText=allDigit{i}(1); 
	message = sprintf('(%g/%g) 按下 Enter 後，請在 %g 秒內唸「%s」（若要跳過此句，請按「n」再按 Enter）：', i, digitNum, duration, displayText);
	fprintf('%s', message);
	userInput = input('', 's');	% 分開成兩部分，才能完整顯示特殊中文，如「淚」、「許」等。
	if isempty(userInput),
		fprintf('錄音中...  ');
		y = wavrecord(duration*fs, fs, format);
		y = double(y);			% Convert from a uint8 to double array
		y = (y-mean(y))/(2^nbits/2);	% Make y zero mean and unity maximum
		plot((1:length(y))/fs, y); grid on
		axis([-inf inf -1 1]);
		title(['Wave form of "', waveFile, '"']);
		wavwrite(y, fs, nbits, waveFile);
		fprintf('結束錄音。若錄音效果不理想，直接刪除檔案（%s）即可。\n\n', waveFile);
	end
end

fprintf('恭喜！錄音結束！\n');