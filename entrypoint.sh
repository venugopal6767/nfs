#!/bin/bash

# Create users from secrets file (if not present)
SECRETS_FILE="/mnt/secrets/nfs-users.txt"
if [ -f "$SECRETS_FILE" ]; then
  while IFS= read -r user; do
    # Check if the user already exists, if not, create the user with /usr/sbin/nologin shell
    if ! id "$user" &>/dev/null; then
      useradd -r -s /usr/sbin/nologin "$user"
      echo "User $user created."
    else
      echo "User $user already exists."
    fi
  done < "$SECRETS_FILE"
fi

# Add export entry to /etc/exports for shared directory
EXPORTS_FILE="/etc/exports"
if ! grep -q "/mnt/jobfile-run" "$EXPORTS_FILE"; then
  echo "/mnt/jobfile-run *(rw,sync,no_subtree_check)" >> "$EXPORTS_FILE"
  echo "Export entry added to /etc/exports."
fi

# Re-export NFS shares based on /etc/exports
exportfs -r

# Start NFS server services
rpcbind
rpc.nfsd

# Keep the container running (this ensures the container doesn't exit)
tail -f /dev/null