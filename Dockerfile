FROM ubuntu:16.04
MAINTAINER shamotj@gmail.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -fy software-properties-common

#Add repository that contains the landscape server
RUN add-apt-repository ppa:landscape/18.03
RUN apt-get update
RUN apt-get -fy install landscape-server apache2 libpq-dev

RUN for module in rewrite proxy_http ssl headers expires; do a2enmod $module; done
RUN a2dissite 000-default

COPY assets/landscape-service.conf /etc/landscape/service.conf
COPY assets/apache-landscape.conf /etc/apache2/sites-available/landscape.conf

COPY assets/certs/landscape_server.key /etc/ssl/private/
COPY assets/certs/landscape_server.pem /etc/ssl/certs/
COPY assets/certs/landscape_server_ca.crt /etc/ssl/certs/

RUN a2ensite landscape.conf

COPY assets/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
