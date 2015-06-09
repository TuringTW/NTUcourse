import pyaudio
import time
import numpy as np

WIDTH = 2 #int32
CHANNELS = 1
RATE = 10240
audio_size = 512
#shift property
semi_shift = -0.00001
print('semi_shift:' + str(semi_shift))
shift_ratio = np.exp2(semi_shift/12)
print('shift_ratio:' + str(shift_ratio))
#freq property
freq = np.fft.rfftfreq(audio_size, 1/RATE) 
s_freq = freq*shift_ratio
print(s_freq - freq)
freqsize = s_freq.size
#volume
volume = 2
#pyAudio
p = pyaudio.PyAudio()


def callback(in_data, frame_count, time_info, status):
	global RATE, shift_ratio, freq, s_freq, audio_size, freqsize, volume
	# preprocessing 
		# translate text base data to array and kill nan and inf
	audio_data = np.nan_to_num(np.fromstring(in_data, dtype=np.int32))
	# fft
	fft_data = np.fft.rfft(audio_data)
	#freq shift
	s_fft = np.zeros(freqsize, dtype = np.complex128)
	ii = 0
	jj = 0
	freq_diff = freq[1] - freq[0]
	while ii < freqsize:
		#linear shift
		#print(freqsize, s_fft.size)
		#print('freq+1='+str(freq[jj+1]),';s_freq='+str(s_freq[ii]))
		if freq[jj+1] <= s_freq[ii]:
			jj = jj + 1
			pass
		s_fft[jj] += (fft_data[ii])*(1-(s_freq[ii]-freq[jj])/freq_diff)

		#print('i='+str(ii)+';j='+str(jj))
		s_fft[jj+1] += (fft_data[ii])*((s_freq[ii]-freq[jj])/freq_diff)
		#print('ratio='+str(((s_freq[ii]-freq[jj])/freq_diff)))
		#print('ratio1='+str(1-((s_freq[ii]-freq[jj])/freq_diff)))
		#print(s_fft[jj+1])
		ii = ii + 1
		pass
	#print(s_fft.size)
	#post processing
	audio_data = np.fft.irfft(s_fft*volume, audio_size)
	out_data = audio_data.astype(np.int32).tostring()
	print((s_fft - fft_data)/fft_data)
	return(out_data, pyaudio.paContinue)
	pass

stream = p.open(format=p.get_format_from_width(WIDTH),
                channels=CHANNELS,
                rate=RATE,
                input=True,
                output=True,
                input_device_index=0,
                output_device_index=1,
                stream_callback=callback)

stream.start_stream()
while stream.is_active():
    time.sleep(0)
    

stream.stop_stream()
stream.close()

p.terminate()
