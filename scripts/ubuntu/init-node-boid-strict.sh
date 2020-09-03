#!/bin/sh

SSHD_LOC=/etc/ssh/sshd_config
MOTD_LOC=/etc/motd
LOGO="┏━┳━┳━┳━┓┏━┳┓╋╋┏┓
┃┏┫┃┃╋┃┳┛┃┃┃┣━┳┛┣━┓
┃┗┫┃┃┓┫┻┓┃┃┃┃╋┃╋┃┻┫
┗━┻━┻┻┻━┛┗┻━┻━┻━┻━┛
══════════════════════════════════════════════════
TYPE: Node //Boid//
OS: $(lsb_release -d | cut -f2-)
IP: $(hostname -I)
INIT: $(date +"%Y-%m-%dT%H:%M:%SZ")
══════════════════════════════════════════════════
Notice: This server is for authorized use only.
By continuing, you agree to the Security policy
of CORE FOUNDATION, nadacia.
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

# Switch User
# su - $USER

exit 0
