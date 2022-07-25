# ON THE SERVER  ################################################

yum install vsftpd.x86_64
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig
vim /etc/vsftpd/vsftpd.conf

#-----------------------------------------------------------
#ADD/MODIFY the conf file to have the following lines present and not commented:
# Do not type this as commands, should be lines in the vsftpd.conf file

anonymous_enable=NO
connect_from_port_20=YES
chroot_local_user=NO
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
pasv_promiscuous=YES
pasv_enable=YES


#-----------------------------------------------------------------

# now type the following as commands
# Create a user 
useradd -m -c "Ravi Saive, CEO" -s /bin/bash ravi
# Set that user password
passwd ravi

# tyoe a password twice


#Populate the ravi home with a file (run as user ravi)
su - ravi -c "cp /data/BDP1_2021/trivial/shining.txt.gz /home/ravi/"
ls -l /home/ravi

# Add the user to the file of authorized users with the following command:

echo "ravi" | tee -a /etc/vsftpd.userlist

# now check that the username is present in the userlist file
cat /etc/vsftpd.userlist

# you should see one line containing ravi

#we are ready to start he service

systemctl start vsftpd.service
systemctl status vsftpd.service


###########################################################

### ON THE CLIENT   #######################################

yum install ftp
ftp 172.31.41.138   # USE THE FTP SERVER PRIVATE IP!!

#now autentiate as ravi and type the ravi's password

#in the FTP command line interface tpe ftp commands
ls
pwd
help
binary # set binary transfer file
put filename
get filename
exit #or CTRL+D

##############################################################
##############################################################

# Now repeat the transfer from a machine outside the securiyt group, i.e. your laptop or a VM on another security group - hint at lease port 20 and 21 sshould be accessible
#more info on ftp ports: https://www.jscape.com/blog/bid/80512/active-v-s-passive-ftp-simplified
