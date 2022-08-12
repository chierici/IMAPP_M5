################################################
# ON THE SERVER  

yum -y install nano wget vsftpd.x86_64
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig
nano /etc/vsftpd/vsftpd.conf

################################################
#EDIT the config file following the instructions

# line 12: no anonymous
anonymous_enable=NO

# line 82,83: uncomment ( allow ascii mode )
ascii_upload_enable=YES
ascii_download_enable=YES

# line 101, 102: uncomment ( enable chroot )
chroot_local_user=YES
chroot_list_enable=YES


# line 110: uncomment
ls_recurse_enable=YES

# line 115: change ( if use IPv4 )
listen=YES

# line 124: change ( turn to OFF if it's not need )
listen_ipv6=NO

# add follows to the end
# specify root directory ( if don't specify, users' home directory become FTP home directory)

userlist_deny=NO

# use localtime
use_localtime=YES

# turn off for seccomp filter ( if you cannot login, add this line )
seccomp_sandbox=NO

# end of the config file edit, save and close the editor

#-----------------------------------------------------------------

# now type the following commands
# Create a user 
useradd -m -c "Mazinga Z" -s /bin/bash mazinga
# Set that user password
passwd mazinga

# type the password twice

# Populate mazinga home with a file (run as user mazinga)
su - mazinga # we become the mazinga user to populate the homedir
wget http://centos.mirror.garr.it/centos/7/os/x86_64/images/efiboot.img
wget http://centos.mirror.garr.it/centos/7/os/x86_64/GPL
wget http://centos.mirror.garr.it/centos/7/os/x86_64/EULA
ls -l 
exit # now you are back to root user

# Add the user to the file of authorized users with the following command:
echo "mazinga" >> /etc/vsftpd/user_list

# now check that the username is present in the userlist file
cat /etc/vsftpd/user_list

# you should see one line containing mazinga

#############################
# start the ftp service
systemctl start --now vsftpd

# verify it's working fine
systemctl status vsftpd

###########################################################

### ON THE CLIENT   #######################################

yum -y install ftp
ftp <PRIVATE_IP>   # USE THE FTP SERVER PRIVATE IP!!

# now autentiate as mazinga and type the password

#in the FTP command line interface tpe ftp commands
ls
pwd
help
binary # set binary transfer file
put filename
get filename
exit # or CTRL+D
