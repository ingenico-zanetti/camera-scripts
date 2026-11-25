# Check pour CFB
# And mount it when found

# Check for the device
#
while [ "$(grep nvme0n1p1 /proc/partitions)" == "" ]
do
	echo "nvme0n1p1 partition not present (yet)"
	sleep 1
done

# Mount the device if not already mounted
device=/dev/nvme0n1p1
mounted=$(mount|grep ${device})
if [ "" == "${mounted}" ]
then
	echo "nvme0n1p1 partition not mounted yet"
	mount /media/CFB
fi

mount
read toto


