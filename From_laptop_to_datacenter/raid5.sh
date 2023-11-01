# Add 3 new disks to your virtual machine through the vm page
# now start the machine and check if the disks are on-line

sudo su -
lsblk

# you should see sdb, sdc and sdd listed
# now let's create partitions on these disks
parted --script /dev/sdb mklabel msdos mkpart primary ext4 1MiB 10GB
parted --script /dev/sdc mklabel msdos mkpart primary ext4 1MiB 10GB
parted --script /dev/sdd mklabel msdos mkpart primary ext4 1MiB 10GB

# now check again to verify partions have been created

lsblk

# now create the raid5 device

mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

# check the building process
cat /proc/mdstat

# check again the status of block devices. Now md0 shoud appear
lsblk

# check the status of raid devices
mdadm -E /dev/sd[b-d]1
mdadm --detail /dev/md0

# now we can format the device and make it available to the system
mkfs.ext4 /dev/md0
mkdir /mnt/raid5
mount /dev/md0 /mnt/raid5/
ls -l /mnt/raid5/

# now let's simulate a failing disk
mdadm --manage /dev/md0 --fail /dev/sdb1

# check the status of the raid device now
cat /proc/mdstat

# now we remove the failing disk from the raid set
mdadm --manage /dev/md0 --remove /dev/sdb1
cat /proc/mdstat
mdadm --detail /dev/md0

# test if the device mounted on the machine is still working
ls -l /mnt/raid5/
touch /mnt/raid5/test_with_failing_disk

# let's try to add again our disk
mdadm --manage /dev/md0 --add /dev/sdb1
cat /proc/mdstat

# check again the device
ls -l /mnt/raid5/
touch /mnt/raid5/test_with_recovered_disk
ls -l /mnt/raid5/

# we simulated a disk failure, replacing it with a new one.
