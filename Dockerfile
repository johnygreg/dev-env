FROM ubuntu:21.04

RUN apt update && apt upgrade -y && \
  apt install -y \
  iputils-ping \
  dumb-init \
  nano \
  wget \
  sudo \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  software-properties-common
  
### Install docker cli
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  install -y docker-ce-cli

### Install Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

### Install Docker Compose
RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 chmod +x /usr/local/bin/docker-compose

### Install font Fira Code
RUN apt install fonts-firacode

### Install Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN adduser --gecos '' --disabled-password dev && \
  echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

COPY root/ /

### Set the time zone
ENV TZ=America/Toronto
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

USER 1000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD [ "/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080" ]