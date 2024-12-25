# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Install necessary packages: NFS server, RPC bind, and bash
RUN apt-get update && apt-get install -y \
    nfs-kernel-server \
    rpcbind \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Create the directory that will be shared over NFS
RUN mkdir -p /mnt/jobfile-run \
    && chmod 777 /mnt/jobfile-run

# Copy the secrets file into the container (in the directory /mnt/secrets)
COPY ./secrets/nfs-users.txt /mnt/secrets/nfs-users.txt

# Expose the necessary NFS port
EXPOSE 2049

# Add the entrypoint script to create NFS users, configure exports, and start the NFS server
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define the entrypoint to execute the script
ENTRYPOINT ["/entrypoint.sh"]

