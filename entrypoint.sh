#!/bin/sh

# # Check if secrets_nfs.env exists
# if [ ! -f "secrets_nfs.env" ]; then
#   echo "*** (ERROR) *** secrets_nfs.env not found! Exiting."
#   exit 1
# fi

# Source the secrets_nfs.env file
. ../secrets_nfs.env

# Check if the NFS_USER exists by looking in /etc/passwd
if ! grep -q "^$NFS_USER:" /etc/passwd; then
  echo "User $NFS_USER does not exist. Creating user..."

  # Create the user with default UID/GID and set the shell to /sbin/nologin
  adduser -D -s /sbin/nologin "$NFS_USER"

  # Set the password for the user (plaintext password)
  echo "$NFS_USER:$NFS_PASS" | chpasswd
else
  echo "User $NFS_USER already exists."
fi

# Start necessary services (e.g., NFS server or others)
rpcbind
nfsd

# Keep the container running
tail -f /dev/null
