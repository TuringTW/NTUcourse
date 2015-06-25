t=0:0.1:4*pi;
y=sin(t)+rand(1, length(t));
plot(t, y, '.-');
hold on
lmax = local_max(y);
for i = 1:length(lmax);
	handle = plot(t(lmax(i)),y(lmax(i)),'o');
	set(handle,'MarkerEdgeColor','red')
	text(t(lmax(i))+0.1,y(lmax(i)),['(' num2str(t(lmax(i))) ',' num2str(round(100*y(lmax(i)))/100) ')'])
end






