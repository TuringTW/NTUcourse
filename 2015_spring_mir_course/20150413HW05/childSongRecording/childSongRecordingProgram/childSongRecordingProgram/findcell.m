function index = findcell(cell_str, pattern)
% FINDCELL "find" for cell arrays of strings
%	Usage:
%	INDEX = FINDCELL(CELL, PATTERN)
%	CELL: cell array of strings to be searched
%	PATTERN: searched string (which could be [])
%	INDEX: indices of matched cell

%	Roger Jang, 981107

index = [];
for i = 1:length(cell_str),
	if ~isempty(findstr(cell_str{i}, pattern)),
		index = [index, i];
	end
end
