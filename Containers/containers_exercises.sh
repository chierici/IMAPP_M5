#######################################
####### INSTALL DOCKER on CENTOS7 
#######################################
# become superuser
sudo su -

# installing useful tools
yum -y install nano wget curl

# install the docker repo
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo 

# install docker
yum --enablerepo=docker-ce-stable -y install docker-ce 

# start docker
systemctl enable --now docker
systemctl status docker

# now you should give to users that need to use docker the docker group
usermod -g docker <username> # not needed for user root

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

docker login
docker images
docker tag 5c2538cecdc2 ataruz/imap_2022:ubuntu_with_ping_1.0
docker push ataruz/imap_2022:ubuntu_with_ping_1.0

############################################
# Bulding docker images using Dockerfiles

mkdir -p containers/simple
cp Dockerfile index.html containers/simple/
cd containers/simple/

# Create a Dockerfile like this
# cat Dockerfile
FROM ubuntu
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y apache2
ENV DEBIAN_FRONTEND=noninteractive
COPY index.html /var/www/html/
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]

# Create a index.html file like this
# cat index.html
<!DOCTYPE html>
<html>
<h1>Hello from a web server running inside a container!</h1>

This is an exercise for the IMAPP2022 course.
</html>

# let's put all this together
docker images
docker build -t ubuntu_web_server .
docker images
docker ps -a
docker run -d -p 8080:80 ubuntu_web_server
docker ps
ip a

# Check that everything works opening in a browser this page: http://<VM_ip_address>:8080/
# PAY ATTENTION TO THE SECURITY GROUP

# to attach a shell...
docker exec -ti  <docker ID> /bin/bash 

# inside the container verify the web server is running
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

docker stop <docker ID>

##################################################
# attach a volume to a docker container

docker volume create some-volume

docker volume ls 
docker volume inspect some-volume
docker volume rm some-volume

docker run -i -t --name myname -v some-volume:/app ubuntu /bin/bash
docker volume rm <volume_name>
docker volume prune

#########################################
#########  Docker compose
#########################################
yum -y install docker-compose

# cat docker-compose.yml
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
docker-compose up --build --no-start
docker-compose start

# Check that everything works opening in a browser this page: http://<VM_ip_address>:8080/ 

# now we can stop everything
docker-compose stop
docker-compose down
docker images
docker system prune
