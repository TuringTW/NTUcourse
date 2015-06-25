waveFile='highPitch.wav';
au=myAudioRead(waveFile); y=au.signal; fs=au.fs;
index1=39200;
frameSize=600;
index2=index1+frameSize-1;
frame=y(index1:index2);

subplot(2,2,1); plot(y); grid on
title(waveFile);
line(index1*[1 1], [-1 1], 'color', 'r');
line(index2*[1 1], [-1 1], 'color', 'r');
subplot(2,2,3); plot(frame, '.-'); grid on
point=[149, 222];

line(point, frame(point), 'marker', 'o', 'color', 'red');



periodCount=3;
fp=((point(2)-point(1))/periodCount)/fs;	% fundamental period
ff=fs/((point(2)-point(1))/periodCount);	% fundamental frequency
pitch=69+12*log2(ff/440);
fprintf('High Pitch\n');
fprintf('Fundamental period = %g second\n', fp);
fprintf('Fundamental frequency = %g Hertz\n', ff);
fprintf('Pitch = %g semitone\n', pitch);

waveFile='lowPitch.wav';
au=myAudioRead(waveFile); y=au.signal; fs=au.fs;
index1=39200;
frameSize=600;
index2=index1+frameSize-1;
frame=y(index1:index2);

subplot(2,2,2); plot(y); grid on
title(waveFile);
line(index1*[1 1], [-1 1], 'color', 'r');
line(index2*[1 1], [-1 1], 'color', 'r');
subplot(2,2,4); plot(frame, '.-'); grid on
point=[123, 558];

line(point, frame(point), 'marker', 'o', 'color', 'red');

periodCount=3;
fp=((point(2)-point(1))/periodCount)/fs;	% fundamental period
ff=fs/((point(2)-point(1))/periodCount);	% fundamental frequency
pitch=69+12*log2(ff/440);
fprintf('Low Pitch\n');
fprintf('Fundamental period = %g second\n', fp);
fprintf('Fundamental frequency = %g Hertz\n', ff);
fprintf('Pitch = %g semitone\n', pitch);


% hold on
% lmax = local_max(frame*(1));
% for i = 1:length(lmax);
% 	handle = plot(lmax(i),frame(lmax(i)),'o');
% 	set(handle,'MarkerEdgeColor','red')
% 	text(lmax(i)+0.1,frame(lmax(i)),['(' num2str(lmax(i)) ',' num2str(round(100*frame(lmax(i)))/100) ')'])
% end
