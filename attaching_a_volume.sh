df -h             #check the mounted filesystem
fdisk -l          #list the attached disks
fdisk /dev/sdb    #use your disk label obtained by the previous command

######## PAY ATTENTION AND AVOID FORMATTING THE SYSTEM DISK!!!!!!!!!!
# now you have an interactive interface to create a new partition in the disk, use teh commands p, n, p, w keep the defaults
# fdisk commands: p, n (primary partition and use the defaults), p, w

mkfs.ext4 /dev/sdb1   # create the ext4 filesystem
mkdir /data2          # create a mountpoint for the new filesystem
yum install vim       # if not present
vim /etc/fstab        # edit the fstab file
# add this line at the end of the fstab file:    /dev/sdb1     /data2  ext4 defaults 0 0

###############################
#Inspect the fstab file
[root@ip-172-31-12-71 ~]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Jan 28 15:24:25 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=4a1c93d9-eb47-4f96-9f3d-920e52dc8cca /                       xfs     defaults        0 0
/dev/sdb1     /data2  ext4 defaults 0 0
##########################################################

df -h
mount -a    #mount all the filesystem listed in the fstab file
df -h   #check the differences
ll /data2
chmod 775 /data2/
