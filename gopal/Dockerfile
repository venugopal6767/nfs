# Use Python image with Alpine
FROM python:3.11-alpine

# Install necessary packages: NFS server, RPC bind, bash, and uvicorn for FastAPI
RUN apk add --no-cache \
    nfs-utils \
    rpcbind \
    bash \
    && pip install --no-cache-dir fastapi uvicorn

# Create the directory that will be shared over NFS
RUN mkdir -p /mnt/jobfile-run \
    && chmod 777 /mnt/jobfile-run

# Expose the necessary NFS port and FastAPI port
EXPOSE 2049
EXPOSE 8000

# Copy the entrypoint script into the container (without --chmod)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set permissions manually
RUN chmod 755 /usr/local/bin/entrypoint.sh

# Set the working directory to /app and copy your app code
WORKDIR /app
COPY app.py /app

# Set the entrypoint for the container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]