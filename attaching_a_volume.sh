###############################
# Inspect the storage on VM
sudo -if		# we neet do be root@ip-172-31-12-71
df -h           #check the mounted filesystem
lsblk          	#list the attached disks

###############################
# We partition the new disk
parted --script /dev/sdb mklabel msdos mkpart primary ext4 1MiB 10GB
lsblk			# you should now see sdb1 below sdb disk, with approx 9GB

mkfs.ext4 /dev/sdb1   	# create the ext4 filesystem
mkdir /data2          	# create a mountpoint for the new filesystem
yum -y install nano       	# if not present
lsblk -o name,uuid		# identify sdb1 uuid
nano /etc/fstab        	# edit the fstab file
# add this line at the end of the fstab file:    
UUID=<the uuid associated to sdb1>     /data2  ext4 defaults 0 0

###############################
#Verify the fstab file
cat /etc/fstab

# it should contain the line regarding data2 mount point

###############################
# We now mount the new filesystem on /data2
df -h
mount -a    			# mount all the filesystem listed in the fstab file
df -h   				# check the differences
touch /data2/foobar
ll /data2
chmod 775 /data2/
