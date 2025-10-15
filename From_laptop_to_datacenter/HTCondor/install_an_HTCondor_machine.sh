#
# This hands-on requires el8 OS (so please install Rocky Linux 8 optimized for GCP)

# INSTALL DEPENDENCIES
sudo -i
yum install -y wget nano git

# Install minicondor on EL8
wget https://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
rpm --import RPM-GPG-KEY-HTCondor
cd /etc/yum.repos.d
wget https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel8.repo
yum config-manager --set-enabled powertools
yum install -y minicondor
 
# CONDOR BASIC CONFIGURATION
nano /etc/condor/condor_config
systemctl status condor
systemctl enable --now condor
systemctl status condor
ps -ef | grep condor
 
# Some hints on network
Security Group must allow tcp for ports 0 - 65535 from the same security group, i.e.:
 All TCP    TCP      0 - 65535     sg-008742ba0467986fe (aws_condor)

Security group must allow ping from the same security group, i.e.:
 All    ICMP-IPv4   All    N/A     sg-008742ba0467986fe (aws_condor)

Security group must allow ssh on port 22 from everywhere as usual
 
# Now that HTCondor is installed, proceed with HTCondor_quickstart.txt 

