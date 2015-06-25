[z, fs] = audioread('selfintro.aac');
time = (1:length(z))'/fs;
y(:, 1) = z .* sin((2*2*pi)*time);
y(:, 2) = z .* cos((2*2*pi)*time);
sound(y,fs);
subplot(2,1,1);plot((1:length(y))/fs,y(:, 1));
subplot(2,1,2);plot((1:length(y))/fs,y(:, 2));
