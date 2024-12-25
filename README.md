# Navigate to the project directory
cd nfs

# Generate secrets file
make secrets

# Build the NFS server Docker image
docker build -t nfs-server .

# Start the containers
docker-compose up -d

# Access the NFS server container
docker exec -it nfs-server bash

cd /mnt/jobfile-run

echo "this is nfs-test" > test.txt
exit

# Access the NFS client container and verify the file
docker exec -it ubuntu-client bash

cd /mnt/jobfile-run

ls

# Stop and remove all containers
docker-compose down -v
