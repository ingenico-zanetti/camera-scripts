#include <linux/input.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, const char *argv[]){
	const char *inputPath = "/dev/input/by-path/platform-pwr_button-event";
	if(argc > 1){
		inputPath = argv[1];
	}
	int fd = open(inputPath, O_RDONLY);
	if(fd != -1){
		int zero = 0;
		int one = 1;
		int result = ioctl(fd, EVIOCGRAB, &one);
		if(-1 != result){
			struct input_event currentEvent;
			struct timeval keyDown, keyUp, delta;
			fprintf(stderr, "sizeof(struct input_event)=%d" "\n", sizeof(struct input_event));
			for(;;){
				int lus = read(fd, &currentEvent, sizeof(currentEvent));
				if(lus > 0){
					fprintf(stderr, "lus=%d" "\n", lus);
					fprintf(stderr, ".tvsec=%lu, .tvusec=%lu, .type=%d, .code=%d, .value=%d" "\n",
							currentEvent.input_event_sec,
							currentEvent.input_event_usec,
							currentEvent.type,
							currentEvent.code,
							currentEvent.value);
					if((currentEvent.type == EV_KEY) && (currentEvent.code == KEY_POWER)){
						if(currentEvent.value == 1){
							keyDown.tv_sec  = currentEvent.input_event_sec;
							keyDown.tv_usec = currentEvent.input_event_usec;
						}else if(currentEvent.value == 0){
							keyUp.tv_sec  = currentEvent.input_event_sec;
							keyUp.tv_usec = currentEvent.input_event_usec;
							timersub(&keyUp, &keyDown, &delta);
							fprintf(stderr, "delta=%lu.%06lu" "\n", delta.tv_sec, delta.tv_usec);
							if(delta.tv_sec > 1){
								// Initiate shutdown
								result = system("touch /tmp/shutdown"); // prevent record from restarting
								result = system("kill $(ps aux |grep \"\\./h264stream\"|grep -v grep | awk '{print $2'})");
								fprintf(stderr, "%s@%d:result=%i" "\n", __func__, __LINE__, result);
								for(int i = 0 ; i < 100 ; i++){
									result = system("ps aux |grep ffmpeg|grep h264|grep -v sh");
									fprintf(stderr, "%s@%d:result=%i" "\n", __func__, __LINE__, result);
									if(0 == result){
										usleep(100000);
									}else{
										break;
									}
								}
								result = system("sync");
								fprintf(stderr, "%s@%d:result=%i" "\n", __func__, __LINE__, result);
								result = system("sudo shutdown -h now");
								fprintf(stderr, "%s@%d:result=%i" "\n", __func__, __LINE__, result);
							}
						}
					}

				}else{
					break;
				}
			}
		}else{
			perror("ioctl");
		}
		close(fd);
	}else{
		perror(inputPath);
	}
	return(0);
}

