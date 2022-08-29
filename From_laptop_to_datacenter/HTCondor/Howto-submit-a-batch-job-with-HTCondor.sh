# Reference documentation: https://htcondor.readthedocs.io/en/latest/users-manual/quick-start-guide.html#quick-start-guide

# Download the HTCondor folder on your linux machine
chmod 755 sleep.sh

# Now we submit the job to our system
condor_submit sleep.sub

# Quickly after submitting the job try these commands:
condor_q
condor_q -better-analyze  

# When the job is finished try this:
condor_history <jobID>

# Examine the job log file and also the error log:
less sleep.out
less sleep.err

