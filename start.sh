# Spawn an ssh-agent
eval $(/usr/bin/ssh-agent -a /tmp/ssh-agent.sock)
DOCKERID=$(basename $(head -1 /proc/self/cgroup))
while true; do
   	sleep 60
	# First, see if we've moved on
	name=$(docker ps -f id=$DOCKERID --format='{{.Names}}')
	if [[ $name != STALE.* ]]; then
		continue
	fi
	# Now see if we're the only process left running
	# bash, ps, ssh-agent
	psout=$(ps -ef --no-headers)
	nprocs=$(echo "$psout" | wc -l)
	if [[ $nprocs -eq 3 ]]; then
		kill $SSH_AGENT_PID
		exit 0
	fi
done
