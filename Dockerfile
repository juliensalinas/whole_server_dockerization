FROM ubuntu:xenial

# Copy the whole system except what is specified in .dockerignore
COPY / /

# Reinstall nginx and rabbitmq because of permissions issues in Docker
RUN apt remove -y nginx
RUN apt install -y nginx
RUN apt remove -y rabbitmq-server
RUN apt install -y rabbitmq-server

# Launch all services
COPY startup.sh /
RUN chmod 777 /startup.sh
CMD ["bash","/startup.sh"]

