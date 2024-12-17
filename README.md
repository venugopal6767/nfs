# nfs


commands to execute
cd nfs
make secrets
docker build -t nfs-server .
docker-compose up -d (to run in detached mode)

to check mount 
docker exec -it nfs-server bash
cd /mnt/jobfile-run
echo "this is nfs-test" > test.txt
exit

docker exec -it ubuntu-client bash
cd /mnt/jobfile-run
ls ( you will find the file which is created in nfs-server)
