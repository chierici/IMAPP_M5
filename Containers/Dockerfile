FROM ubuntu
RUN apt update &&  apt install -y –no-install-recommends apache2
COPY index.html /var/www/html/
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
