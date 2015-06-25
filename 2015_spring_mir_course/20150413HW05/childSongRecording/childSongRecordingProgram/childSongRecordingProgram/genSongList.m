midiFiles=dir('midi\*.mid');
midiNum=length(midiFiles);

% ====== Generate songList.txt
songListFile='songList.txt';
fid=fopen(songListFile, 'w');
for i=1:midiNum
	fprintf(fid, '%s_0\r\n', midiFiles(i).name(1:end-4));
end
fclose(fid);

% ====== Generate index.htm for midi directory
indexFile='midi/index.htm';
fid=fopen(indexFile, 'w');
fprintf(fid, '<ol>\r\n');
for i=1:midiNum
	fprintf(fid, '<li><a href="%s">%s</a>\r\n', midiFiles(i).name, midiFiles(i).name);
end
fprintf(fid, '</ol>\r\n');
fclose(fid);