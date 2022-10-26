# INSTALL DEPENDENCIES
yum install -y wget nano
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum localinstall epel-release-latest-7.noarch.rpm
yum clean all
 
 
# INSTALL CONDOR REPOs and PACKAGES
curl https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo -o /etc/yum.repos.d/htcondor-stable-rhel7.repo
yum -y install minicondor
 
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
 
