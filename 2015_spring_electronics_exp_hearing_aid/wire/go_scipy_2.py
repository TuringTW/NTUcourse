import pyaudio
import time
import numpy as np

WIDTH = 2 #int32
CHANNELS = 2
RATE = 10000
audio_size = 1024
#shift property
semi_shift = -5
print('semi_shift:' + str(semi_shift))
shift_ratio = np.exp2(semi_shift/12)
print('shift_ratio:' + str(shift_ratio))
#freq property
freq = np.fft.rfftfreq(int(audio_size/2), 1/RATE) 
s_freq = freq*shift_ratio
freqsize = s_freq.size
print(freqsize) #257
#pyAudio
p = pyaudio.PyAudio()


def callback(in_data, frame_count, time_info, status):
	global RATE, shift_ratio, freq, s_freq, audio_size, freqsize

	# preprocessing 
		# translate text base data to array and kill nan and inf
	audio_data = np.nan_to_num(np.fromstring(in_data, dtype=np.int32))
	audio_data = np.reshape(audio_data, (frame_count, 2))
	# fft
	L_fft_data = np.fft.rfft(L_data, int(audio_size/2))
	R_fft_data = np.fft.rfft(R_data, int(audio_size/2))
	#freq shift
		#L
	s_L_fft = np.zeros(freqsize, dtype = np.complex128)
	ii = 0
	jj = 0
	freq_diff = freq[1] - freq[0]
	while ii < freqsize:
		#linear shift
		s_L_fft[jj] += (L_fft_data[ii])*(1-(s_freq[ii]-freq[jj])/freq_diff)
		s_L_fft[jj+1] += (L_fft_data[ii])*((s_freq[ii]-freq[jj])/freq_diff)
		if freq[jj+1] <= s_freq[ii]:
			jj = jj + 1
			pass
		ii = ii + 1
		pass
		#R
	s_R_fft = np.zeros(freqsize, dtype = np.complex128)
	ii = 0
	jj = 0
	freq_diff = freq[1] - freq[0]
	while ii < freqsize:
		#linear shift
		s_R_fft[jj] += (R_fft_data[ii])*(1-(s_freq[ii]-freq[jj])/freq_diff)
		s_R_fft[jj+1] += (R_fft_data[ii])*((s_freq[ii]-freq[jj])/freq_diff)
		if freq[jj+1] <= s_freq[ii]:
			jj = jj + 1
			pass
		ii = ii + 1
		pass
	#post processing
	L_data = np.fft.irfft(s_L_fft, audio_size)
	R_data = np.fft.irfft(s_R_fft, audio_size)
	audio_data = np.append(L_data,R_data)
	out_data = audio_data.astype(np.int32).tostring()
	
	return(out_data, pyaudio.paContinue)
	pass

stream = p.open(format=p.get_format_from_width(WIDTH),
                channels=CHANNELS,
                rate=RATE,
                input=True,
                output=True,
                stream_callback=callback)

stream.start_stream()
while stream.is_active():
    time.sleep(0)
    

stream.stop_stream()
stream.close()

p.terminate()