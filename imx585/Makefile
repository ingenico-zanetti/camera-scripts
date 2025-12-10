install:camera
	mkdir -p ~/bin
	cp -vf audiorecord_*.bash  audiostream_*.bash h264record.bash  h264stream.bash ~/bin

camera:camera.c
	$(CC) -o camera camera.c

