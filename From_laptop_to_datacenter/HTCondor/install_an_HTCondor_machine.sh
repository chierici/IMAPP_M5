#
# This hands-on requires almalinux 9 OS 

# INSTALL DEPENDENCIES
sudo -i
yum install -y wget nano git

# Install minicondor
dnf install -y https://htcss-downloads.chtc.wisc.edu/repo/25.x/htcondor-release-current.el9.noarch.rpm
dnf install -y minicondor
 
# CONDOR BASIC CONFIGURATION
nano /etc/condor/condor_config
systemctl status condor
systemctl enable --now condor
systemctl status condor
ps -ef | grep condor
 
# Now that HTCondor is installed, proceed with HTCondor_quickstart.txt 

