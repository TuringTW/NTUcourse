import pyaudio
import time
import numpy as np
import scipy.signal as signal

WIDTH = 2
CHANNELS = 2
RATE = 16000
#shift property
semi_shift = 0
shift_ratio = np.exp2(semi_shift/12)
#freq property
freq = np.fft.fftfreq(1024, 1/RATE) 
#pyAudio
p = pyaudio.PyAudio()

# b,a=signal.iirdesign(0.03,0.07,5,40)
# fulldata = np.array([])


def callback(in_data, frame_count, time_info, status):
	global RATE, shift_ratio, freq
	# preprocessing
	audio_data = np.fromstring(in_data, dtype=np.float32)
	audio_data = np.nan_to_num(audio_data);
	# fft
	fft_data = np.fft.rfft(audio_data)
	#freq shift
	s_freq = freq*shift_ratio
	s_fft = np.zeros(fft_data.size)

	i = 0
	j = 0
	freq_diff = freq[1] - freq[0]
	while i < freq.size-1:
		#linear shift
		s_fft[j] += fft_data[i]*(1-(s_freq[i]-s_freq[j])/freq_diff)
		s_fft[j] += fft_data[i]*((s_freq[i]-s_freq[j])/freq_diff)

		if s_freq[j] <= freq[i]:
			j = j + 1
			pass
		i = i + 1
		pass


	#post processing
	out_data = np.fft.irfft(fft_data, len(fft_data))
	audio_data = out_data.astype(np.float32).tostring()
	
	# fulldata = np.append(fulldata,audio_data)

	return(audio_data, pyaudio.paContinue)
	pass

stream = p.open(format=p.get_format_from_width(WIDTH),
                channels=CHANNELS,
                rate=RATE,
                input=True,
                output=True,
                stream_callback=callback)

stream.start_stream()
i = 0
while stream.is_active():
    time.sleep(0)
    

stream.stop_stream()
stream.close()

p.terminate()