% Child song recording. The songs are obtained from "songlist.txt".
% Roger Jang, 20050328, 20110411, 20140403

% ====== Add Utility Toolbox and SAP Toolbox to the search path
addpath d:/users/jang/matlab/toolbox/utility
addpath d:/users/jang/matlab/toolbox/sap

% ====== MATLAB version check
desiredVersion='7';
matlabVersion=version;
if ~strcmp(matlabVersion(1:length(desiredVersion)), desiredVersion)
	fprintf('Recommended MATLAB version：%s\n', desiredVersion);
end

% ====== Options for recording
duration = 8;
fs = 8000;
nbits = 8;
waveDir = '../waveFile';

if exist(waveDir, 'dir') ~= 7,
	fprintf('Making wave directory => %s\n', waveDir);
	mkdir(waveDir);
end

% ====== Obtain ID and name
validInput=0;
while ~validInput
	name = input('Please enter your student ID and real name (for example, 921510_張智星): ', 's');
%	validName = name(find(name>=double('一')));		% 保留中文：國字的「一」是最短筆劃的字
	validName = name(find(name>=double('0')));		% 保留中英文和數字
	if length(validName)>=2, validInput=1; end
end
userDir = [waveDir, '/', validName]; 
if exist(userDir, 'dir') ~= 7,
	fprintf('Making personal wave directory => %s\n', userDir);
	mkdir(userDir);
end

% ====== Find pre-existing recordings
recordTextFile = 'songList.txt';
fprintf('Reading song list from %s...\n', recordTextFile);
allTexts = textread(recordTextFile,'%s','delimiter','\n','whitespace','');
existingWaveFile = dir([waveDir, '/', validName, '/*.wav']);
deleteIndex = [];
for i=1:length(existingWaveFile),
	waveFile = existingWaveFile(i).name(1:end-4);
	index = findcell(allTexts, waveFile);
	if ~isempty(index),
		deleteIndex = [deleteIndex, index];
	end
end

remaining = allTexts;
remaining(deleteIndex) = [];
fileNum = length(remaining);
if length(deleteIndex)>0,
	fprintf('Dear %s, you have finished %d recordings!\n', validName, length(deleteIndex));
end
if length(remaining),
	fprintf('You still need to do %d recordings!\n\n', length(remaining));
end

for i=1:fileNum,
	temp=split(remaining{i}, '_');
	songName=temp{1}; singer = temp{2}; fromMiddle = eval(temp{3});
	if fromMiddle==0
		startPos='the beginning';
	else
		startPos='middle';
	end
	message = sprintf('(%g/%g) Title: %s, artist: %s\n\tTo start recording ==> Press "Enter"\n\tTo skip the song ==> Press "s" and "Enter"\n\tTo hear the song ==> Press "p" and "Enter"\n', i, fileNum, songName, singer);
	fprintf('%s', message);
	userInput = input('', 's');	% 分開成兩部分，才能完整顯示特殊中文，如「淚」、「許」等。
	skip=0;
	while ~isempty(userInput)
		switch lower(userInput)
			case 'p'
				sourceMidiFile=['midi\', songName, '_', singer, '.mid'];
				targetMidiFile=[tempname, '.mid'];
				copyfile(sourceMidiFile, targetMidiFile);	% Copy to a temp file for using file path without spaces
				cmd=['start ', targetMidiFile];
			%	disp(cmd);
				dos(cmd);
			case 's'
				skip=1;
				break;
        	end
        	fprintf('%s', message);
		userInput = input('', 's');	% 分開成兩部分，才能完整顯示特殊中文，如「淚」、「許」等。
        end
	if ~skip
		outputFile = [waveDir, '/', validName, '/', remaining{i}, '.wav'];
		waveFileRecord(duration, fs, nbits, outputFile, songName, 1);
		fprintf('\t%s\n\n', ['Finish recording. (If the recording is bad, you can delete "', outputFile, '" directly and run this program again.)']);
	end
end

fprintf('Congratulations, you have finished all the recordings!\n');