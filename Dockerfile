FROM ubuntu:18.04

# Install Mumble server
RUN apt-get update && \
    apt-get install --no-install-suggests -y \
        busybox \
        cron \
        mumble-server \
        openssl1.0 \
        wget && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Set busybox alias for vi
RUN echo "alias vi='busybox vi'" >> /root/.bashrc

# Insatll acme.sh for SSL cert generation
RUN wget -O - https://github.com/Neilpang/acme.sh/archive/master.tar.gz | tar -xz && \
    cd acme.sh-master && \
    bash acme.sh --install \
        --home /acme.sh && \
    cd ../ && \
    rm -rf acme.sh-master

# Copy in config templates
ADD config/*.ini /

# Copy in scripts
ADD scripts/*.sh /
RUN chmod 744 /*.sh

CMD ["bash", "/docker-cmd.sh"]
