import pyaudio
import time
import numpy as np

WIDTH = 2
CHANNELS = 2
RATE = 44100

p = pyaudio.PyAudio()


def callback(in_data, frame_count, time_info, status):
	return(in_data, pyaudio.paContinue)
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