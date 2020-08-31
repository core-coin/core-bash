#!/bin/sh

SSHD_LOC=/etc/ssh/sshd_config
MOTD_LOC=/etc/motd
LOGO="┏━┳━┳━┳━┓┏━┳┓╋╋┏┓\
┃┏┫┃┃╋┃┳┛┃┃┃┣━┳┛┣━┓\
┃┗┫┃┃┓┫┻┓┃┃┃┃╋┃╋┃┻┫\
┗━┻━┻┻┻━┛┗┻━┻━┻━┻━┛\
══════════════════════════════════════════════════\
TYPE: Node //Boid//\
OS: $(lsb_release -d | cut -f2-)\
IP: $(hostname -I)\
INIT: $(date +"%Y-%m-%dT%H:%M:%SZ")\
══════════════════════════════════════════════════\
Notice: This server is for authorized use only.\
By continuing, you agree to the Security policy\
of CORE FOUNDATION, nadacia.\
══════════════════════════════════════════════════"

# Gather user name
if [ -z "$1" ]; then
  USER=boid
else
  USER="$1"
fi

# Gather user password & and new user
if [ -z "$2" ]; then
  exit 1
else
  useradd -p $(openssl passwd -1 $2) $USER
fi

# Add new user to sudo group
usermod -aG sudo $USER

# Copy SSH keys from root
mkdir /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
cp /root/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys
chmod 600 /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER/.ssh

# No root login with password (no)
( echo "" ; echo "PermitRootLogin no" ) >> $SSHD_LOC
# No password authentication
sed -i '/^PasswordAuthentication/s/yes/no/' $SSHD_LOC
# Change login time
( echo "" ; echo "LoginGraceTime 10" ) >> $SSHD_LOC
# Authorization tries (1)
( echo "" ; echo "MaxAuthTries 1" ) >> $SSHD_LOC
# Max Sessions (1)
( echo "" ; echo "MaxSessions 1" ) >> $SSHD_LOC
# Client Alive interval (300) 5min
( echo "" ; echo "ClientAliveInterval 300" ) >> $SSHD_LOC
# Client Alive count max (1)
( echo "" ; echo "ClientAliveCountMax 1" ) >> $SSHD_LOC
# Motto of the day
sed -i '/^PrintMotd/s/no/yes/' $SSHD_LOC

# Write intro
echo $LOGO > $MOTD_LOC

# Restart SSH
systemctl restart sshd

# Disable root
passwd -dl root

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Start Docker at server start
sudo systemctl enable docker

# Get latest docker compose released tag
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Install docker-compose
sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

# Switch User
# su - $USER

exit 0
