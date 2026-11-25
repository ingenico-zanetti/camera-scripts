# Check pour CFB
# And mount it when found

# Check for the device
#
device=/dev/nvme0n1p1
while [ "$(grep nvme0n1p1 /proc/partitions)" == "" ]
do
	sleep 1
done

# Mount the device if not already mounted
mounted=$(mount|grep ${device})
if [ "" == "${mounted}" ]
then
	mount /media/CFB
fi

