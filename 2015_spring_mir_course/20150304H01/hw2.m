function output = myShape(A)
	output = reshape(A, size(A,1)*size(A,2),3)';
end