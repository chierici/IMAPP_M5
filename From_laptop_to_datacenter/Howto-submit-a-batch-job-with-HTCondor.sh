#####################################
# get the condor dir with examples
 
cp -r /data/BDP1_2022/condor/ .
cd condor
#####################################
 
#### inspect files ##################
#### for first example ##############
cat myexec.sh
cat world.txt
vim first_batch.job
#####################################
 
######### check the condor cluster###
condor_status
######################################
 
 
# now the condor submission #########
condor_submit first_batch.job
 
### check job status ################
condor_q
condor_q -better-analyze  
condor_q -better-analyze  < jobID >
condor_history < jobID >  #for already done jobs
######################################
 
### inspect out files ################
cat file1out
cat file2out
less condor.out
less condor.log
less condor.error
 
 
################  now the HG example with bwa ###############
#############################################################
 
cd hg
vim  align.py  
vim bwa_batch.job  
less condor.error  
less condor.log  
less condor.out  
cat md5.txt
 
###############################################################
