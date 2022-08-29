# Reference documentation: https://htcondor.readthedocs.io/en/latest/users-manual/quick-start-guide.html#quick-start-guide

# Download the HTCondor folder on your linux machine

##########################
# First example: sleep job
##########################

chmod 755 sleep.sh

# Now we submit the job to our system
condor_submit sleep.sub

# Quickly after submitting the job try these commands:
condor_q
condor_q -better-analyze  

# When the job is finished try this:
condor_history <jobID>

# Examine the log, output and error files:
less sleep.log
less sleep.out
less sleep.err

###########################
# Second example: inout job
###########################

chmod 755 inout.sh
condor_submit inout.sub

# Examine the log, output and error files:
less inout.log
less inout.out
less inout.err

###########################
# Third example: inout10 job
###########################
# Now we want to run 10 instances of the previous job, with same input files and different output files

# modify inout.sub 
cp inout.sub inout10.sub

# add 10 after directive "queue"
# modify inout.out in inout$(Process).out

condor_submit inout10.sub

# Examine the log, error and all the 10 output files

################################
# Fourth example: inout10dir job
################################
# Now we want to run 10 instances with separate working dirs. First of all we create the dirs and add files into them:
for i in `seq 0 9`;do mkdir run$i; cp file1 file2 run$i;done

# modify inout.sub 
cp inout.sub inout10dir.sub

# add 10 after directive "queue"
# Add this line before log one:
# initialdir              = run$(Process)

condor_submit inout10dir.sub

# Examine the log, error and output inside each directory



