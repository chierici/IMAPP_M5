#INSTALL DEPENDENCIES
yum install wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum localinstall epel-release-latest-7.noarch.rpm
yum clean all
 
 
#INSTALL CONDOR REPOs and PACKAGES
wget http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo
cp htcondor-stable-rhel7.repo /etc/yum.repos.d/
yum install condor-all
 
#CONDOR BASIC CONFIGURATION
cd
vim /etc/condor/condor_config
systemctl status condor
systemctl start condor
systemctl enable condor
systemctl status condor
ps -aux | grep condor
 
# END - SOME HINTS BELOW
1) Security Group must allow tcp for ports 0 - 65535 from the same security group, i.e.:
 All TCP    TCP      0 - 65535     sg-008742ba0467986fe (aws_condor)
Security group must allow ping from the same security group, i.e.:
 All    ICMP-IPv4   All    N/A     sg-008742ba0467986fe (aws_condor)
Security group must allow ssh on port 22 from everywhere as ususal
 
##################################
 
 
#-------------------------------------
# In the config file add at the end
# the most important variable is the CONDOR_HOST running the master
 
# ADD the following lines to your condor_config file
# CHANGE THE FOLLOWING IP TO YOUR MASTER IP
CONDOR_HOST = __put here the master Private IP address, i.e.: 172.31.25.191 ___
 
# on the master
DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, STARTD, SCHEDD
 
# #on the nodes
# #DAEMON_LIST = MASTER, STARTD
 
 
HOSTALLOW_READ = *
HOSTALLOW_WRITE = *
HOSTALLOW_ADMINISTRATOR = *
#---------------------------------------------
 
 
#Depending on your flavor of Unix. On a central manager machine that can submit jobs as well as execute them, there will be processes for:
 
    condor_master
    condor_collector
    condor_negotiator
    condor_startd
    condor_schedd
 
On a central manager machine that does not submit jobs nor execute them, there will be processes for:
 
    condor_master
    condor_collector
    condor_negotiator
 
For a machine that only submits jobs, there will be processes for:
 
    condor_master
    condor_schedd
 
For a machine that only executes jobs, there will be processes for:
    condor_master
    condor_startd
 
USE PRIVATE IPs!!
[root@aws_ui1 ~]# cat   /etc/condor/condor_config
######################################################################
##
##  condor_config
##
##  This is the global configuration file for condor. This is where
##  you define where the local config file is. Any settings
##  made here may potentially be overridden in the local configuration
##  file.  KEEP THAT IN MIND!  To double-check that a variable is
##  getting set from the configuration file that you expect, use
##  condor_config_val -v <variable name>
##
##  condor_config.annotated is a more detailed sample config file
##
##  Unless otherwise specified, settings that are commented out show
##  the defaults that are used if you don't define a value.  Settings
##  that are defined here MUST BE DEFINED since they have no default
##  value.
##
######################################################################
 
##  Where have you installed the bin, sbin and lib condor directories?
RELEASE_DIR = /usr
 
##  Where is the local condor directory for each host?  This is where the local config file(s), logs and
##  spool/execute directories are located. this is the default for Linux and Unix systems.
LOCAL_DIR = /var
 
##  Where is the machine-specific local config file for each host?
LOCAL_CONFIG_FILE = /etc/condor/condor_config.local
##  If your configuration is on a shared file system, then this might be a better default
#LOCAL_CONFIG_FILE = $(RELEASE_DIR)/etc/$(HOSTNAME).local
##  If the local config file is not present, is it an error? (WARNING: This is a potential security issue.)
REQUIRE_LOCAL_CONFIG_FILE = false
 
##  The normal way to do configuration with RPMs is to read all of the
##  files in a given directory that don't match a regex as configuration files.
##  Config files are read in lexicographic order.
LOCAL_CONFIG_DIR = /etc/condor/config.d
#LOCAL_CONFIG_DIR_EXCLUDE_REGEXP = ^((\..*)|(.*~)|(#.*)|(.*\.rpmsave)|(.*\.rpmnew))$
 
##  Use a host-based security policy. By default CONDOR_HOST and the local machine will be allowed
use SECURITY : HOST_BASED
##  To expand your condor pool beyond a single host, set ALLOW_WRITE to match all of the hosts
#ALLOW_WRITE = *.cs.wisc.edu
##  FLOCK_FROM defines the machines that grant access to your pool via flocking. (i.e. these machines can join your pool).
#FLOCK_FROM =
##  FLOCK_TO defines the central managers that your schedd will advertise itself to (i.e. these pools will give matches to your schedd).
#FLOCK_TO = condor.cs.wisc.edu, cm.example.edu
 
##--------------------------------------------------------------------
## Values set by the rpm patch script:
##--------------------------------------------------------------------
 
## For Unix machines, the path and file name of the file containing
## the pool password for password authentication.
#SEC_PASSWORD_FILE = $(LOCAL_DIR)/lib/condor/pool_password
 
##  Pathnames
RUN     = $(LOCAL_DIR)/run/condor
LOG     = $(LOCAL_DIR)/log/condor
LOCK    = $(LOCAL_DIR)/lock/condor
SPOOL   = $(LOCAL_DIR)/lib/condor/spool
EXECUTE = $(LOCAL_DIR)/lib/condor/execute
BIN     = $(RELEASE_DIR)/bin
LIB = $(RELEASE_DIR)/lib64/condor
INCLUDE = $(RELEASE_DIR)/include/condor
SBIN    = $(RELEASE_DIR)/sbin
LIBEXEC = $(RELEASE_DIR)/libexec/condor
SHARE   = $(RELEASE_DIR)/share/condor
 
PROCD_ADDRESS = $(RUN)/procd_pipe
 
JAVA_CLASSPATH_DEFAULT = $(SHARE) $(SHARE)/scimark2lib.jar .
 
SSH_TO_JOB_SSHD_CONFIG_TEMPLATE = /etc/condor/condor_ssh_to_job_sshd_config_template
 
##  Install the minicondor package to run HTCondor on a single node
#
 
# CHANGE THE FOLLOWING IP TO YOUR MASTER IP
CONDOR_HOST = 172.31.89.103
 
# on the master
DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, STARTD, SCHEDD
 
#on the nodes
#DAEMON_LIST = MASTER, STARTD
 
HOSTALLOW_READ = *
HOSTALLOW_WRITE = *
HOSTALLOW_ADMINISTRATOR = *
