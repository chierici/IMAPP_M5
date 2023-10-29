# Adapted from https://www.vultr.com/docs/how-to-setup-a-webdav-server-using-apache-on-centos-7

# On The Server
# enable the epel repository, you should have this file:
yum -y install epel-release

####

# Install Apache using YUM:
yum -y install nano httpd policycoreutils-python-utils

# Disable Apache's default welcome page:
sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf

# Prevent the Apache web server from displaying files within the web directory:
sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf

# Start the service 
systemctl enable --now httpd.service

# issue this command
httpd -M | grep dav

# You should see as output something like
#   dav_module (shared)
#   dav_fs_module (shared)
#   dav_lock_module (shared)

mkdir /var/www/html/webdav
chown apache:apache /var/www/html/webdav
chmod 755 /var/www/html/webdav

# Create a virtual host for WebDAV

nano /etc/httpd/conf.d/webdav.conf

# Populate it with the following content

<Directory /var/www/html/webdav>
 Dav on
</Directory>
<VirtualHost *:80>
 ServerName mydav.host.com
 Alias /webdav /var/www/html/webdav
</VirtualHost>

# restart httpd service to load webdav configuration
systemctl restart httpd.service

# If SELinux is enabled, add rules to allow accesses to target WebDAV directory:
chcon -R -t httpd_sys_rw_content_t /var/www/html/webdav
semanage fcontext -a -t httpd_sys_rw_content_t /var/www/html/webdav

#############################################################

# On the Client

yum -y install cadaver
touch pippo pluto

cadaver http://<your-server-ip>/webdav/


# To upload a file in your home dir, like "/home/user/abc.txt" to the WebDAV server:

dav:/webdav/> put pippo

# To create a directory "dir1" on the WebDAV server:

dav:/webdav/> mkdir dir1

# To quit the cadaver shell:

dav:/webdav/> exit
###############################################################



# Repeat the exercise having the client installed on your laptop, or use your browser (hint: open port 80)

# NOTE: 
# You can only access specific files with a browser with WebDAV, like : https://domain/webdav/folder1/test.pdf
# It's not like an FTP server where you can browse inside your folders.
# If you want to browse your folders with your browser, you might need a WebDAV browser plugin.
# Why ? because the browser is using classic HTTP methods and WebDAV is an extension of it with more methods.
# The browser might not be compatible with those extension methods like PROPFIND.
