import pyaudio
import time
import numpy as np
import sys
import os
if len(sys.argv)!=3:
	print('Enter shift semitone!!!')
	sys.exit(0)
	pass
WIDTH = 2 #int32
CHANNELS = 2
RATE = 16000 #7000
audio_size = 1024 #1024
#shift property
semi_shift = float(sys.argv[1])
linear_shift = -100;
print('semi_shift:' + str(semi_shift))
shift_ratio = np.exp2(semi_shift/12)
print('shift_ratio:' + str(shift_ratio))
#freq property
freq = np.fft.rfftfreq(audio_size, 1/RATE) 
s_freq = freq*shift_ratio
freqsize = s_freq.size
#volume
volume = int(sys.argv[2])
#pyAudio
p = pyaudio.PyAudio()


def callback(in_data, frame_count, time_info, status):
	global RATE, shift_ratio, freq, s_freq, audio_size, freqsize, volume, linear_shift
	# preprocessing 
		# translate text base data to array and kill nan and inf
	audio_data = np.nan_to_num(np.fromstring(in_data, dtype=np.int32))
	audio_data = np.add(audio_data[0:-51],audio_data[50:-1])

	out_data = audio_data.astype(np.int32).tostring()
	# if os.path.exists('./stop'):
	# 	os.remove('./stop') 
	# 	sys.exit("STOP")
	# 	pass
	return(out_data, pyaudio.paContinue)
	pass

stream = p.open(format=p.get_format_from_width(WIDTH),
                channels=CHANNELS,
                rate=RATE,
                input=True,
                output=True,
                frames_per_buffer=audio_size,
#                input_device_index=0,
#                output_device_index=1,
                stream_callback=callback)

stream.start_stream()
while stream.is_active():
    time.sleep(0)
    

stream.stop_stream()
stream.close()

p.terminate()
