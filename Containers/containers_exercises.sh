#######################################
####### INSTALL DOCKER on Rocky 9
#######################################

# add port 8080 to firewall on google cloud dashboard. See teacher screen.

# become superuser
sudo -i

# installing useful tools
dnf -y install nano wget curl git
dnf --enablerepo=devel install -y elinks

# download the examples from github
git clone https://github.com/chierici/IMAPP_M5.git

# install the docker repo
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo 

# install docker
dnf --enablerepo=docker-ce-stable -y install docker-ce 

# start docker
systemctl enable --now docker
systemctl status docker

#######################
#### start using docker
#######################

docker --version
docker version # more details
docker search ubuntu
docker pull ubuntu
docker run ubuntu echo "hello from the container"
docker run -i -t  ubuntu /bin/bash
#### now you are in a shell running inside the container, remeber to exit to go back in the host shell: type exit or Ctrl+D
docker images
time docker run ubuntu echo "hello from the container"
docker run ubuntu ping www.google.com # something unexpected?
docker run ubuntu /bin/bash -c "apt update; apt -y install iputils-ping"
docker run ubuntu ping www.google.com # still something?
docker run ubuntu /bin/bash -c "apt update; apt -y install iputils-ping; ping -c 5 www.google.com"
docker ps
docker ps -a 
docker images
docker commit <get the container ID using docker ps -a> ubuntu_with_ping
docker images
docker run ubuntu_with_ping ping -c 5 www.google.com
docker system df
docker system prune
docker images
docker ps -a


############################################
# Interacting with docker-hub

docker login -u <userid>
docker images
docker tag <copy_id_of_ubuntu_with_ping> ataruz/imapp_m5:ubuntu_with_ping_1.0
docker push ataruz/imapp_m5:ubuntu_with_ping_1.0

############################################
# Bulding docker images using Dockerfiles

mkdir -p containers/simple
cd IMAPP_M5/Containers/
cp Dockerfile index.html ~/containers/simple/
cd ~/containers/simple/

# Dockerfile should be like this
# cat Dockerfile
FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y apache2
ENV DEBIAN_FRONTEND=noninteractive
COPY index.html /var/www/html/
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]

# index.html file should be like this
# cat index.html
<!DOCTYPE html>
<html>
<h1>Hello from a web server running inside a container!</h1>

This is an exercise for the IMAPP_M5 course.
</html>

# let's put all this together
docker images
docker build -t ubuntu_web_server .
docker images
docker ps -a
docker run -d -p 8080:80 ubuntu_web_server
docker ps
ip a

# Check that everything works opening in a elinks the page:
elinks http://<VM_ip_address>:8080

# to attach a shell...
docker exec -ti  <docker ID> /bin/bash 

# inside the container verify the web server is running (you should see apache2 processes running)
ps -ef

# exit the container with ctrl+d
docker stop <docker ID>

####################################
####  Docker volumes

# map a local directory
mkdir -p $HOME/containers/scratch 
cd $HOME/containers/scratch
head -c 10M < /dev/urandom > dummy_file
docker run -v $HOME/containers/scratch/:/container_data -i -t ubuntu /bin/bash
# try: ll /container_data from inside the container

##################################################
# attach a volume to a docker container

docker volume create some-volume

docker volume ls 
docker volume inspect some-volume
docker volume rm some-volume
docker volume ls  # volume is gone

docker volume create some-volume
docker run -i -t --name myname -v some-volume:/app ubuntu /bin/bash

# remove the volume
docker volume rm <volume_name>
# is previous command working? If not try removing the docker first

docker ps -a
docker rm <id of myname container>
docker volume rm <volume_name>

#########################################
#########  Docker compose
#########################################
cd $HOME
curl -L "https://github.com/docker/compose/releases/download/v5.0.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir p $HOME/containers/compose
cd $HOME/containers/compose
nano docker-compose.yml

# copy this file into the editor window
version: '3'
services:
   database:
      image: mysql:5.7
      environment:
         - MYSQL_DATABASE=wordpress
         - MYSQL_USER=wordpress
         - MYSQL_PASSWORD=testwp
         - MYSQL_RANDOM_ROOT_PASSWORD=yes
      networks:
         - backend
   wordpress:
      image: wordpress:latest
      depends_on:
         - database
      environment:
         - WORDPRESS_DB_HOST=database:3306
         - WORDPRESS_DB_USER=wordpress
         - WORDPRESS_DB_PASSWORD=testwp
         - WORDPRESS_DB_NAME=wordpress
      ports:
         - 8080:80
      networks:
         - backend
         - frontend
networks:
    backend:
    frontend:

#########################################

# now try these commands
/usr/local/bin/docker-compose up --build --no-start
/usr/local/bin/docker-compose start

# Check that everything works opening in a browser this page: http://<VM_ip_address>:8080/ 

# now we can stop everything
/usr/local/bin/docker-compose stop
/usr/local/bin/docker-compose down
docker images
docker system prune

#########################################
#########  apptainer
#########################################
dnf install -y epel-release
dnf install -y apptainer

apptainer help
apptainer pull docker://alpine
ls   # you should see a .sif file, the apptainer container

# with the following command you should see "Rocky Linux", you are not inside a container
cat /etc/os-release|grep ^NAME 

# with the following command you should see "Alpine Linux", you execute the command inside the container
apptainer run alpine_latest.sif cat /etc/os-release|grep ^NAME

# Other examples, let's try lolcow
apptainer pull docker://gcr.io/apptainer/lolcow
apptainer shell lolcow_latest.sif
cowsay "hello IMAPP students"
exit

apptainer exec lolcow_latest.sif cowsay "IMAPP rocks"

# Apptainer containers may contain runscripts. These are user-defined scripts that define the actions a container should perform when someone runs it. 
# The runscript can be triggered with the run command, or simply by calling the container as though it were an executable.

apptainer run lolcow_latest.sif 

# if you are interested in doing some practice, check this quick start page:
# https://apptainer.org/docs/user/main/quick_start.html





