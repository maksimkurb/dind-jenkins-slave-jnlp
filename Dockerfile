FROM jenkins/jnlp-slave

ARG DOCKER_VERSION=5:19.03.1~3-0~debian-stretch
ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update -qq && apt-get install -qqy \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common && \
  rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add --no-tty -
RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable"
# Install Docker from Docker Inc. repositories.
RUN apt-get update -qq && apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io && rm -rf /var/lib/apt/lists/*

ARG ARCH=amd64

COPY gosu/gosu-${ARCH} /usr/local/bin/gosu
COPY setup-docker /usr/local/bin/setup-docker
COPY entrypoint.sh /entrypoint.sh
RUN chmod 555 /usr/local/bin/setup-docker /entrypoint.sh /usr/local/bin/gosu
VOLUME /var/lib/docker

# Make sure that the "jenkins" user from evarga's image is part of the "docker"
# group. Needed to access the docker daemon's unix socket.
RUN usermod -a -G docker jenkins

ENTRYPOINT ["/entrypoint.sh"]
