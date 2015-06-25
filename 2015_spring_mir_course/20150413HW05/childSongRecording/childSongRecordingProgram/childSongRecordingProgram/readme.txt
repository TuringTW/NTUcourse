Before start your recording, please check out the contents of songList.txt:

hictory dickory dock_不詳_0
humpty dumpty_不詳_0
...
十個印第安人_不詳_0
三輪車_不詳_0
...

The format is: songTitle_singerName_positionCode
	songTitle: title of the song
	singerName: name of the singer (where "不詳" means "unknown")
	positionCode: 0 indicates singing from beginning, 1 indicates singing from anywhere. (For this task, it's all singing from the beginning.)

Some of the song titles are in Chinese, which should not be a problem.
You are encouraged to hear the MIDI files first since many famous children's songs have the same tune but different names.

Pleae enter "goRecord" within MATLAB to start your recording. (Be sure to change the lines of "addpath" first.)

The following is Chinese translation:

要錄音前，請先看看歌單 songList.txt，其內容如下：

hictory dickory dock_不詳_0
humpty dumpty_不詳_0
...
十個印第安人_不詳_0
三輪車_不詳_0
...

其格式為：歌名_歌星_位置代碼
	歌名：歌曲的名稱
	歌星：歌曲的原唱者，若不知道此歌曲的原唱者，即為「不詳」
	位置代碼：若是 0，代表從頭唱，若是1，代表從中間唱。（本次錄音都是從頭唱，所以都是 0。）

請在 MATLAB 下輸入 goRecord，即可開始進行錄音。（記得要先修改包含 addpath 的那幾列程式碼。）