################################################
# ON THE SERVER  

sudo -i
dnf -y install nano wget vsftpd.x86_64
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig
nano /etc/vsftpd/vsftpd.conf

################################################
#EDIT the config file following the instructions

# line 82,83: uncomment ( allow ascii mode )
ascii_upload_enable=YES
ascii_download_enable=YES

# line 110: uncomment
ls_recurse_enable=YES

# line 115: change
listen=YES

# line 124: change 
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
wget https://repo.almalinux.org/almalinux/9.4/BaseOS/x86_64/os/images/efiboot.img
wget https://repo.almalinux.org/almalinux/9.4/BaseOS/x86_64/os/LICENSE
wget https://repo.almalinux.org/almalinux/9.4/BaseOS/x86_64/os/EULA
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

dnf -y install ftp
ftp <INTERNAL_IP>   # USE THE FTP SERVER PRIVATE IP!!

# create a dummy file
touch from_client

# now autentiate as mazinga and type the password

#in the FTP command line interface tpe ftp commands
ls
pwd
help
binary # set binary transfer file
put from_client
get EULA
exit # or CTRL+D

# Now chech root home dir
ls -l

# Now check mazinga home dir
ls -l /home/mazinga
