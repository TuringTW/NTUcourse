%% mySongStats: function description
function [out1,out2] = mySongStats(songObj)
	artists = {songObj.artist};
	unique_artists = unique(artists)';
	for i = 1:length(unique_artists)
		artist(i).name = unique_artists(i);
		artist(i).count = sum(strcmp(artists_name,unique_artists(i)));
	end
	out1 = 0;
	out2 = 0;
end		