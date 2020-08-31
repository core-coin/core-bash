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

# No root login with password (prohibit-password)
( echo "" ; echo "PermitRootLogin prohibit-password" ) >> $SSHD_LOC
# No password authentication
sed -i '/^PasswordAuthentication/s/yes/no/' $SSHD_LOC
# Change login time
( echo "" ; echo "LoginGraceTime 30" ) >> $SSHD_LOC
# Authorization tries (3)
( echo "" ; echo "MaxAuthTries 3" ) >> $SSHD_LOC
# Max Sessions (2)
( echo "" ; echo "MaxSessions 2" ) >> $SSHD_LOC
# Client Alive interval (1200) 20min
( echo "" ; echo "ClientAliveInterval 1200" ) >> $SSHD_LOC
# Client Alive count max (1)
( echo "" ; echo "ClientAliveCountMax 1" ) >> $SSHD_LOC
# Motto of the day
sed -i '/^PrintMotd/s/no/yes/' $SSHD_LOC

# Write intro
echo $LOGO > $MOTD_LOC

# Restart SSH
systemctl restart sshd

exit 0
