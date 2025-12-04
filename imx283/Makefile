install:camera
	mkdir -p ~/bin
	cp -vi audiorecord.bash  audiostream.bash  automount.bash  camera h264record.bash  h264stream.bash ~/bin

camera:camera.c
	$(CC) -o camera camera.c

