polyphonic music 合奏
monophonic music 清唱

load handel.mat
sound(y, fs) %play async
% ====
p = audioplayer(y, fs)%create playback object
playblocking(p) %play object sync

% Q:聲音聽起來並沒有變成3或5倍大聲，為什麼？
% A: 聲級室Log函數關係 ，可測試

% 鼻音 noisal sound

% 正規化 聲音調整成-1,1之間
soundsc()

% audible fundemental frequency 20-20000hz

% human speech SUV
% S:silence 沒聲音
% U:unvoice 氣音 聲帶沒震動
% V:Voice 聲帶振動發出聲音

% 3 basic feature: Volume, pitch, timbre


% =====
% frame base analysis

% zerocrossing rate: how many time sound crossing the zero