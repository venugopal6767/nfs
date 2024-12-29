#!/bin/sh

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

# Start rpcbind service (required for NFS to work)
rpcbind

# Start NFS server (nfsd) if installed
nfsd -N 4  # This starts the NFSv4 server

# Start the FastAPI app
echo "Starting FastAPI server..."
exec uvicorn app:app --host 0.0.0.0 --port 8000
