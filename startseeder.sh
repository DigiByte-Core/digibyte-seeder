#  DigiByte Seeder Autostart Script
#------------------------
#  Place in the home directory
#  chmod +x /home/user/startseeder.sh
#------------------------
#  crontab -e
#  @reboot sleep 30 && /home/user/startseeder.sh
#  **************_Script_**************

#!/bin/sh

# ==============================================================

# Add your Digibyte Seeder credentials here:

# This is the address of your seeder e.g. seed.example.com
SEEDER_ADDRESS=seed.example.com

# This is the subdomain to identify your server e.g. server.example.com
SEEDER_SERVER=server.example.com

# This is the SOA email. Replace the @ with a . so youremail@example.com become youremail.example.com
SEEDER_EMAIL=youremail.example.com

# The IP address of the server running your seeder
SEEDER_SERVER_IP=123.123.123.123

# The DNS port. Usually 53 or 5353.
SEEDER_PORT=53

# The chain you are creating the seeder for. Enter either MAIN or TESTNET.
SEEDER_CHAIN=MAIN

# ==============================================================

if [ "$SEEDER_CHAIN" = "TESTNET" ]; then
  CHAIN="--testnet"
elif [ "$SEEDER_CHAIN" = "MAIN" ]; then
  CHAIN=""
fi

SESSION="dgbseeder"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
if [ ! -d "digibyte-seeder/" ]; then
  echo "Error: digibyte-seeder directory not found. Place startseeder.sh in your home directory!"
  exit 1
fi
if [ "$SESSIONEXISTS" = "" ]
then
    tmux new-session -d -s $SESSION
    tmux rename-window -t 0 'dgbseeder'
    tmux send-keys -t 'dgbseeder' '' C-m 'cd digibyte-seeder' C-m clear C-m "./dnsseed -h ${SEEDER_ADDRESS} -n ${SEEDER_SERVER} -m ${SEEDER_EMAIL} -p ${SEEDER_PORT} -a ${SEEDER_SERVER_IP} ${CHAIN}" C-m
    tmux ls
else
  echo "Tmux session active! Open it with ´tmux a -t dgbseeder´"
fi

#  **************_Script_**************
