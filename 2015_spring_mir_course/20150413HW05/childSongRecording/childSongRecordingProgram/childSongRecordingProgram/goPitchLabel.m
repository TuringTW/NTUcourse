% Label pitch of wave files in a given directory

close all; clear all;

% ====== Add necessary toolboxes to the search path
addpath C:/Users/Kevin/Desktop/Programming/MatLab/toolbox/utility
addpath C:/Users/Kevin/Desktop/Programming/MatLab/toolbox/sap
addpath C:/Users/Kevin/Desktop/Programming/MatLab/toolbox/sap/labelingProgram/pitchLabelingProgram

% ====== Directory of the wave files
waveDir='C:\Users\Kevin\Desktop\Programming\MatLab\20150413HW05\childSongRecording\childSongRecordingProgram\waveFile\B02209041';

waveDir=strrep(waveDir, '\', '/');
waveData=recursiveFileList(waveDir, 'wav');
waveNum=length(waveData);
fprintf('Read %d wave files from "%S"\n', waveNum, waveDir);

for i=1:waveNum
	waveFile=waveData(i).path;
	fprintf('%d/%d: Check the pitch of %s...\n', i, waveNum, waveFile);
	wObj=waveFile2obj(waveFile);
	targetPitchFile=[waveFile(1:end-3), 'pv'];
	if exist(targetPitchFile)
		wObj.tPitch=load(targetPitchFile);
	end
	pitchLabel(wObj);
	fprintf('\tHit any key to check next wav file...\n'); pause
	savePitch;
	close all
end