result = [];
datapoint = 20;
multiplier = (15000/100)^(1/datapoint);
for i = 1:datapoint
	result(i) = freqamp(100*multiplier.^(i-1), 0.1);
end
f = (1:datapoint);
semilogx(100*multiplier.^(f-1), result);