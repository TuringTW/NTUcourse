%% mySongStats: function description
function [out1,out2] = mySongStats(songObj)
	%out1
	unique_artists = unique({songObj.artist});
	lang = strcmp({songObj.language},'Chinese') + strcmp({songObj.language},'Taiwanese')*2;
	out2=[];

	unique_artists(find(strcmp('unknown',unique_artists)+strcmp('¦Ñºq',unique_artists)+strcmp('¤£¸Ô',unique_artists))) = [];

	for i = 1:length(unique_artists)
		%count songs
		artist(i).name = unique_artists{i};
		cmp = strcmp({songObj.artist},unique_artists(i));
		artist(i).songCount = sum(cmp);
		%chinese and taiwanese
		if sum(unique(cmp.*lang))==3
			out2 = [out2,unique_artists(i)];
		end
	end
	%out 1 ranking
	[sorted,index] = sort(cat(1,artist.songCount),'descend');
	artist = artist(index);
	%out1
	if length(artist)>10
		out1 = artist(1:10);
	else
		out1 = artist;
	end
	%sort by name
	if ~isempty(out2);
		out2 = sort(out2);
	end
end		