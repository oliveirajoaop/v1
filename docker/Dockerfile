FROM ubuntu:18.04  
LABEL maintainer="orlando.pereira@obconnect.io" 
RUN  apt-get -y update && apt-get -y install nginx
COPY html/index.html /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
# docker tag local-image:tagname new-repo:tagname
# docker push new-repo:tagname
# docker push orlandop43/nginx:tagname
